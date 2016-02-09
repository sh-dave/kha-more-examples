var project = new Project('stencil_triangles');
project.addSources('src');
project.addAssets('assets/**');

project.windowOptions.width = 512;
project.windowOptions.height = 512;

return project;
