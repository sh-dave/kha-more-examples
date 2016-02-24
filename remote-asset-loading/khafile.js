var project = new Project('remote_asset_loading');
project.addSources('../common/src');
project.addSources('src');
project.addLibrary('tink_core');
project.addLibrary('format');
project.addLibrary('hxssl');

project.addAssets('assets/**');

project.windowOptions.width = 512;
project.windowOptions.height = 512;

return project;
