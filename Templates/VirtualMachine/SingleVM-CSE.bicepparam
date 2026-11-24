using './SingleVM-CSE.bicep'

param Prefix = 'iac'
param VMName = 'VM'

param baseConfigScriptUri = 'https://distsacoursestaff.blob.core.windows.net/azvmcsescripts/BaseConfigWSrv.ps1?sp=r&st=2026-10-31T23:00:00Z&se=2036-12-30T23:00:00Z&spr=https&sv=2026-02-06&sr=b&sig=XumLSKdesNgtXcFnzQgqpj5hUCZKlC7z13LCD4XPEDI%3D'

