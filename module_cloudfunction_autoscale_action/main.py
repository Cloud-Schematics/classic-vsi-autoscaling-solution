import requests
import json
import copy

TOKEN_URL = "https://iam.cloud.ibm.com/identity/token"
SCHEMATCIS_API = "https://us-south.schematics.cloud.ibm.com"
ERR_STATUS_CODE = [400, 404, 403, 500, 502]

def get_tokens(apikey, add_user=True):
    refresh_token = ""
    access_token = ""
    # get access token form api-key
    if add_user:
        response = requests.post(TOKEN_URL, data={'grant_type': 'urn:ibm:params:oauth:grant-type:apikey', 'apikey': apikey}, auth=('bx', 'bx'))
    else:
        response = requests.post(TOKEN_URL, data={'grant_type': 'urn:ibm:params:oauth:grant-type:apikey', 'apikey': apikey})
    if response.status_code not in ERR_STATUS_CODE:
        #data = json.loads(response.json())
        data = response.json()
        refresh_token = data['refresh_token']
        access_token = 'Bearer ' + data['access_token']
    return access_token, refresh_token

def get_worksapce_info(access_token, workspace_id):
    schematics_headers = {'Authorization' : access_token}
    response = requests.get(SCHEMATCIS_API+'/v1/workspaces/{}'.format(workspace_id), headers=schematics_headers)
    if response.status_code not in ERR_STATUS_CODE:
        return response.json()

def fetch_vms_count(ws_info):
    temp_data = ws_info['template_data']
    for variable in temp_data[0]['variablestore']:
        if variable['name'] == 'instance_count':
            return variable['value']
    #check this return 0
    return 0

def list_ip_vars(workspace_id, t_id, access_token):
    schematics_headers = {'Authorization' : access_token}
    response = requests.get(SCHEMATCIS_API+'/v1/workspaces/{}/template_data/{}/values'.format(workspace_id, t_id), headers=schematics_headers)
    if response.status_code not in ERR_STATUS_CODE:
        data = response.json()
        return data

def update_workspace_info(ws_info, new_instance_count):

    vars_data = {
        'variablestore' : []
    }
    t_id = ws_info['template_data'][0]['id']

    for i in ws_info['template_data'][0]['variablestore']:
        if i['name'] == 'instance_count':
            i['value'] = str(new_instance_count)
        vars_data['variablestore'].append(i)
    return vars_data, t_id

def is_workspace_available(workspace_id, access_token):
    schematics_headers = {'Authorization' : access_token}
    API = SCHEMATCIS_API+'/v1/workspaces/{}/actions'.format(workspace_id)
    response = requests.get(API, headers=schematics_headers)
    if response.status_code not in ERR_STATUS_CODE:
        data = response.json()
        for action in data['actions']:
            if action['status'] == 'INPROGRESS':
                return False
        return True
    else:
        return False
                

def update_workspace_input_variables(workspace_id, vars_data, t_id, access_token):
    schematics_headers = {'Authorization' : access_token}
    API =  SCHEMATCIS_API+'/v1/workspaces/{}/template_data/{}/values'.format(workspace_id, t_id)
    response = requests.put(API, headers=schematics_headers, data=json.dumps(vars_data))

def apply_plan(ws_id, access_token, refresh_token):
    schematics_headers = {
        'Authorization' : access_token,
        'refresh_token' : refresh_token
    }
    response = requests.put(SCHEMATCIS_API+'/v1/workspaces/{}/apply'.format(ws_id), headers=schematics_headers)
    if response.status_code not in ERR_STATUS_CODE:
        data = response.json()
        return data

def main(args):
    
    query_params = dict([i.split("=") for i in args['__ow_query'].split('&') ])
    apikey = ""
    workspace_id = ""
    vmcount = ""
    min_vms = 3

    if 'apikey' in query_params:
        apikey = query_params['apikey']
    else:
        apikey = args['apikey']

    if 'workspace_id' in query_params:
        workspace_id = query_params['workspace_id']
    else:
        workspace_id = args['workspace_id']
    
    if 'vmcount' in query_params:
        vmcount = int(query_params['vmcount'])

    if 'min_vms' in args:
        min_vms = args['min_vms']

    if  apikey == "" or workspace_id == "":
        print('No apikey or worspaces_id is provided!')
        return {"error" : "No apikey or worspaces_id is provided"}


    access_token, refresh_token = get_tokens(apikey)
    if refresh_token == "" or access_token == "":
        print('Failed to fetch refresh and access tokens') 
        return {"error" : "Failed to fetch refresh and access tokens"}
    
    # Get schematics workspace details and update the same:
    ws_info = get_worksapce_info(access_token, workspace_id)
    vm_count = fetch_vms_count(ws_info)
    new_instance_count = int(vm_count) + int(vmcount)
    if is_workspace_available(workspace_id, access_token) == False:
        return {"status": "workspace not available for action"}
    if new_instance_count >= min_vms:
        vars_data, t_id = update_workspace_info(ws_info, new_instance_count)
        access_token, refresh_token = get_tokens(apikey)
        update_workspace_input_variables(workspace_id, vars_data, t_id, access_token)
        access_token, refresh_token = get_tokens(apikey)
        data = apply_plan(workspace_id, access_token, refresh_token)
        return data
    else:
        return {'status': "normal"}