var project = new Project('system_options_playground');
project.addSources('../common/src');
project.addSources('src');
project.addAssets('assets/**');

project.windowOptions.width = 1366;
project.windowOptions.height = 768;

//project.windowOptions.mode = 'borderless';
//project.windowOptions.x = 128;
//project.windowOptions.y = 128;

return project;
