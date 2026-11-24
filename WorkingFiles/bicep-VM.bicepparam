using './bicep-VM.bicep'

param AdminUser = 'localadmin'
param AdminPwd = getSecret('eec0968d-6c7a-40df-b5a5-a1ce6558617e', 'RG-Iac--Training','iac-kv-017','VMAdminPwd')

