node Kha/make --target flash --to build/flash
node Kha/make --target html5 --to build/html
node Kha/make --target linux --to build/linux
node Kha/make --target windows --visualstudio vs2012 --to build/vs2012-gl --graphics opengl
node Kha/make --target windows --visualstudio vs2012 --to build/vs2012-d3d9 --graphics direct3d9
node Kha/make --target windows --visualstudio vs2012 --to build/vs2012-d3d11 --graphics direct3d11
node Kha/make --target windows --visualstudio vs2012 --to build/vs2012-d3d12 --graphics direct3d12
node Kha/make --target android-native --to build/android-native
node Kha/make --target android --to build/android
node Kha/make --target unity --to build/unity
