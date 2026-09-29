#module_parameters (USE_D3D12_PREVIEW := false);

#scope_module

#import "Windows";
#import "Math";
#import "dxgi";
#if USE_D3D12_PREVIEW {
    #import "d3d12-preview";
} else {
    #import "d3d12";
}

#load "windows.jai";
