::node Kha/make --target android --to build/android
::node Kha/make --target android-native --to build/android-native
node Kha/make --target flash --to build/flash

::node Kha/make --target html5 --to build/html5
::node Kha/make --target windows --to build/vs2012-gl --visualstudio vs2012 --graphics opengl
::node Kha/make --target windows --to build/vs2012-d3d9 --visualstudio vs2012 --graphics direct3d9
::node Kha/make --target windows --to build/vs2012-d3d11 --visualstudio vs2012 --graphics direct3d11
::node Kha/make --target windows --to build/vs2012-d3d12 --visualstudio vs2012 --graphics direct3d12
::node Kha/make --target android --to build/android
