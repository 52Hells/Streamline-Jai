SL_VERSION_MAJOR :: 2;
SL_VERSION_MINOR :: 14;
SL_VERSION_PATCH :: 1;

sl :: struct {
    //! GUID
    StructType :: struct {
        data1: u32;
        data2: u16;
        data3: u16;
        data4: [8] u8;
    }

    //! IMPORTANT: New members in the structure always go at the end!
    //!
    kStructVersion1: u32 : 1;
    kStructVersion2: u32 : 2;
    kStructVersion3: u32 : 3;
    kStructVersion4: u32 : 4;
    kStructVersion5: u32 : 5;
    kStructVersion6: u32 : 6;
    kStructVersion7: u32 : 7;

    BaseStructure :: struct {
        next:          *BaseStructure;
        structType:    StructType;
        structVersion: u64;
    }

    //! For cases when value has to be provided and we don't have good default
    INVALID_FLOAT: float : 0h7F7FFFFF;
    INVALID_UINT: u32 : 4294967295;

    //! Normally host would work with no more than 2 frames at the same time but sl.reflex sometimes
    //! needs to send markers for previous and next frame so the total number of in-flight frames can be higher
    MAX_FRAMES_IN_FLIGHT: u32 : 6;

    uint2 :: struct {
        x: u32;
        y: u32;
    }

    uint3 :: struct {
        x: u32;
        y: u32;
        z: u32;
    }

    float2 :: struct {
        x: float = INVALID_FLOAT;
        y: float = INVALID_FLOAT;
    }

    float3 :: struct {
        x: float = INVALID_FLOAT;
        y: float = INVALID_FLOAT;
        z: float = INVALID_FLOAT;
    }

    float4 :: struct {
        x: float = INVALID_FLOAT;
        y: float = INVALID_FLOAT;
        z: float = INVALID_FLOAT;
        w: float = INVALID_FLOAT;
    }

    float4x4 :: struct {
        //! Row major matrix
        row: [4] float4;
    }

    Extent :: struct {
        top:    u32;
        left:   u32;
        width:  u32;
        height: u32;
    }

    //! For cases when value has to be provided and we don't have good default
    Boolean :: enum u8 {
        eFalse   :: 0;
        eTrue    :: 1;
        eInvalid :: 2;
    }

    //! Common constants, all parameters must be provided unless they are marked as optional
    //!
    //! {DCD35AD7-4E4A-4BAD-A90C-E0C49EB23AFE}
    Constants :: struct {
        s_structType :: StructType.{0xdcd35ad7, 0x4e4a, 0x4bad, .[0xa9, 0xc, 0xe0, 0xc4, 0x9e, 0xb2, 0x3a, 0xfe]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion2};

        //! Specifies matrix transformation from the camera view to the clip space.
        cameraViewToClip:                       float4x4;

        //! Specifies matrix transformation from the clip space to the camera view space.
        clipToCameraView:                       float4x4;

        //! Optional - Specifies matrix transformation describing lens distortion in clip space.
        clipToLensClip:                         float4x4;

        //! Specifies matrix transformation from the current clip to the previous clip space.
        //! clipToPrevClip = clipToView * viewToViewPrev * viewToClipPrev
        //! Sample code can be found in sl_matrix_helpers.h
        clipToPrevClip:                         float4x4;

        //! Specifies matrix transformation from the previous clip to the current clip space.
        //! prevClipToClip = clipToPrevClip.inverse()
        prevClipToClip:                         float4x4;

        //! Specifies pixel space jitter offset
        jitterOffset:                           float2;

        //! Specifies scale factors used to normalize motion vectors (so the values are in [-1,1] range)
        mvecScale:                              float2;

        //! Optional - Specifies camera pinhole offset if used.
        cameraPinholeOffset:                    float2;

        //! Specifies camera position in world space.
        cameraPos:                              float3;

        //! Specifies camera up vector in world space.
        cameraUp:                               float3;

        //! Specifies camera right vector in world space.
        cameraRight:                            float3;

        //! Specifies camera forward vector in world space.
        cameraFwd:                              float3;

        //! Specifies camera near view plane distance.
        cameraNear:                             float = INVALID_FLOAT;

        //! Specifies camera far view plane distance.
        cameraFar:                              float = INVALID_FLOAT;

        //! Specifies camera field of view in radians.
        cameraFOV:                              float = INVALID_FLOAT;

        //! Specifies camera aspect ratio defined as view space width divided by height.
        cameraAspectRatio:                      float = INVALID_FLOAT;

        //! Specifies which value represents an invalid (un-initialized) value in the motion vectors buffer
        //! NOTE: This is only required if `cameraMotionIncluded` is set to false and SL needs to compute it.
        motionVectorsInvalidValue:              float = INVALID_FLOAT;

        //! Specifies if depth values are inverted (value closer to the camera is higher) or not.
        depthInverted:                          Boolean = .eInvalid;

        //! Specifies if camera motion is included in the MVec buffer.
        cameraMotionIncluded:                   Boolean = .eInvalid;

        //! Specifies if motion vectors are 3D or not.
        motionVectors3D:                        Boolean = .eInvalid;

        //! Specifies if previous frame has no connection to the current one (i.e. motion vectors are invalid)
        reset:                                  Boolean = .eInvalid;

        //! Specifies if orthographic projection is used or not.
        orthographicProjection:                 Boolean = .eFalse;

        //! Specifies if motion vectors are already dilated or not.
        motionVectorsDilated:                   Boolean = .eFalse;

        //! Specifies if motion vectors are jittered or not.
        motionVectorsJittered:                  Boolean = .eFalse;

        //! Version 2 members:
        //!
        //! Optional heuristic that specifies the minimum depth difference between two objects in screen-space.
        //! The units of the value are in linear depth units.
        //! Linear depth is computed as:
        //!     if depthInverted is false:  `lin_depth = 1 / (1 - depth)`
        //!     if depthInverted is true:   `lin_depth = 1 / depth`
        //!
        //! Although unlikely to need to be modified, smaller thresholds are useful when depth units are
        //! unusually compressed into a small dynamic range near 1.
        //!
        //! If not specified, the default value is 40.0f.
        minRelativeLinearDepthObjectSeparation: float = 40.0;
    }

    kSDKVersionMagic: u64 : 65244;
    kSDKVersion: u64 : (2 << 48) | (14 << 32) | (1 << 16) | kSDKVersionMagic;

    Version :: struct {
        major: u32 = 0;
        minor: u32 = 0;
        build: u32 = 0;
    }

    Result :: enum s32 {
        eOk                              :: 0;
        eErrorIO                         :: 1;
        eErrorDriverOutOfDate            :: 2;
        eErrorOSOutOfDate                :: 3;
        eErrorOSDisabledHWS              :: 4;
        eErrorDeviceNotCreated           :: 5;
        eErrorNoSupportedAdapterFound    :: 6;
        eErrorAdapterNotSupported        :: 7;
        eErrorNoPlugins                  :: 8;
        eErrorVulkanAPI                  :: 9;
        eErrorDXGIAPI                    :: 10;
        eErrorD3DAPI                     :: 11;

        eErrorNRDAPI                     :: 12;
        eErrorNVAPI                      :: 13;
        eErrorReflexAPI                  :: 14;
        eErrorNGXFailed                  :: 15;
        eErrorJSONParsing                :: 16;
        eErrorMissingProxy               :: 17;
        eErrorMissingResourceState       :: 18;
        eErrorInvalidIntegration         :: 19;
        eErrorMissingInputParameter      :: 20;
        eErrorNotInitialized             :: 21;
        eErrorComputeFailed              :: 22;
        eErrorInitNotCalled              :: 23;
        eErrorExceptionHandler           :: 24;
        eErrorInvalidParameter           :: 25;
        eErrorMissingConstants           :: 26;
        eErrorDuplicatedConstants        :: 27;
        eErrorMissingOrInvalidAPI        :: 28;
        eErrorCommonConstantsMissing     :: 29;
        eErrorUnsupportedInterface       :: 30;
        eErrorFeatureMissing             :: 31;
        eErrorFeatureNotSupported        :: 32;
        eErrorFeatureMissingHooks        :: 33;
        eErrorFeatureFailedToLoad        :: 34;
        eErrorFeatureWrongPriority       :: 35;
        eErrorFeatureMissingDependency   :: 36;
        eErrorFeatureManagerInvalidState :: 37;
        eErrorInvalidState               :: 38;
        eWarnOutOfVRAM                   :: 39;
    }

    //! Engine types
    //!
    EngineType :: enum u32 {
        eCustom :: 0;
        eUnreal :: 1;
        eUnity  :: 2;
        eCount  :: 3;
    }

    //! Rendering API
    //!
    RenderAPI :: enum u32 {
        eD3D11  :: 0;
        eD3D12  :: 1;
        eVulkan :: 2;
        eCount  :: 3;
    }

    CommandBuffer :: void;
    Device :: void;

    //! Buffer types used for tagging
    //!
    //! IMPORTANT: Each tag must use the unique id
    //!
    BufferType :: u32;

    //! Depth buffer - IMPORTANT - Must be suitable to use with clipToPrevClip transformation (see Constants below)
    kBufferTypeDepth: BufferType : 0;

    //! Object and optional camera motion vectors (see Constants below)
    kBufferTypeMotionVectors: BufferType : 1;

    //! Color buffer with all post-processing effects applied but without any UI/HUD elements
    kBufferTypeHUDLessColor: BufferType : 2;

    //! Color buffer containing jittered input data for the image scaling pass
    kBufferTypeScalingInputColor: BufferType : 3;

    //! Color buffer containing results from the image scaling pass
    kBufferTypeScalingOutputColor: BufferType : 4;

    //! Normals
    kBufferTypeNormals: BufferType : 5;

    //! Roughness
    kBufferTypeRoughness: BufferType : 6;

    //! Albedo
    kBufferTypeAlbedo: BufferType : 7;

    //! Specular Albedo
    kBufferTypeSpecularAlbedo: BufferType : 8;

    //! Indirect Albedo
    kBufferTypeIndirectAlbedo: BufferType : 9;

    //! Specular Motion Vectors
    kBufferTypeSpecularMotionVectors: BufferType : 10;

    //! Disocclusion Mask
    kBufferTypeDisocclusionMask: BufferType : 11;

    //! Emissive
    kBufferTypeEmissive: BufferType : 12;

    //! Exposure
    kBufferTypeExposure: BufferType : 13;

    //! Buffer with normal and roughness in alpha channel
    kBufferTypeNormalRoughness: BufferType : 14;

    //! Diffuse and camera ray length
    kBufferTypeDiffuseHitNoisy: BufferType : 15;

    //! Diffuse denoised
    kBufferTypeDiffuseHitDenoised: BufferType : 16;

    //! Specular and reflected ray length
    kBufferTypeSpecularHitNoisy: BufferType : 17;

    //! Specular denoised
    kBufferTypeSpecularHitDenoised: BufferType : 18;

    //! Shadow noisy
    kBufferTypeShadowNoisy: BufferType : 19;

    //! Shadow denoised
    kBufferTypeShadowDenoised: BufferType : 20;

    //! AO noisy
    kBufferTypeAmbientOcclusionNoisy: BufferType : 21;

    //! AO denoised
    kBufferTypeAmbientOcclusionDenoised: BufferType : 22;

    //! Optional - UI/HUD color and alpha
    //! IMPORTANT: Please make sure that alpha channel has enough precision (for example do NOT use formats like R10G10B10A2)
    kBufferTypeUIColorAndAlpha: BufferType : 23;

    //! Optional - Shadow pixels hint (set to 1 if a pixel belongs to the shadow area, 0 otherwise)
    kBufferTypeShadowHint: BufferType : 24;

    //! Optional - Reflection pixels hint (set to 1 if a pixel belongs to the reflection area, 0 otherwise)
    kBufferTypeReflectionHint: BufferType : 25;

    //! Optional - Particle pixels hint (set to 1 if a pixel represents a particle, 0 otherwise)
    kBufferTypeParticleHint: BufferType : 26;

    //! Optional - Transparency pixels hint (set to 1 if a pixel belongs to the transparent area, 0 otherwise)
    kBufferTypeTransparencyHint: BufferType : 27;

    //! Optional - Animated texture pixels hint (set to 1 if a pixel belongs to the animated texture area, 0 otherwise)
    kBufferTypeAnimatedTextureHint: BufferType : 28;

    //! Optional - Bias for current color vs history hint - lerp(history, current, bias) (set to 1 to completely reject history)
    kBufferTypeBiasCurrentColorHint: BufferType : 29;

    //! Optional - Ray-tracing distance (camera ray length)
    kBufferTypeRaytracingDistance: BufferType : 30;

    //! Optional - Motion vectors for reflections
    kBufferTypeReflectionMotionVectors: BufferType : 31;

    //! Optional - Position, in same space as eNormals
    kBufferTypePosition: BufferType : 32;

    //! Optional - Indicates (via non-zero value) which pixels have motion/depth values that do not match the final color content at that pixel (e.g. overlaid, opaque Picture-in-Picture)
    kBufferTypeInvalidDepthMotionHint: BufferType : 33;

    //! Alpha
    kBufferTypeAlpha: BufferType : 34;

    //! Color buffer containing only opaque geometry
    kBufferTypeOpaqueColor: BufferType : 35;

    //! Optional - Reduce reliance on history instead using current frame hint (0 if a pixel is not at all reactive and default composition should be used, 1 if fully reactive)
    kBufferTypeReactiveMaskHint: BufferType : 36;

    //! Optional - Pixel lock adjustment hint (set to 1 if pixel lock should be completely removed, 0 otherwise)
    kBufferTypeTransparencyAndCompositionMaskHint: BufferType : 37;

    //! Optional - Albedo of the reflection ray hit point. For multibounce reflections, this should be the albedo of the first non-specular bounce.
    kBufferTypeReflectedAlbedo: BufferType : 38;

    //! Optional - Color buffer before particles are drawn.
    kBufferTypeColorBeforeParticles: BufferType : 39;

    //! Optional - Color buffer before transparent objects are drawn.
    kBufferTypeColorBeforeTransparency: BufferType : 40;

    //! Optional - Color buffer before fog is drawn.
    kBufferTypeColorBeforeFog: BufferType : 41;

    //! Optional - Buffer containing the hit distance of a specular ray.
    kBufferTypeSpecularHitDistance: BufferType : 42;

    //! Optional - Buffer that contains 3 components of a specular ray direction, and 1 component of specular hit distance.
    kBufferTypeSpecularRayDirectionHitDistance: BufferType : 43;

    //! Optional - Buffer containing normalized direction of a specular ray.
    kBufferTypeSpecularRayDirection: BufferType : 44;

    // !Optional - Buffer containing the hit distance of a diffuse ray.
    kBufferTypeDiffuseHitDistance: BufferType : 45;

    //! Optional - Buffer that contains 3 components of a diffuse ray direction, and 1 component of diffuse hit distance.
    kBufferTypeDiffuseRayDirectionHitDistance: BufferType : 46;

    //! Optional - Buffer containing normalized direction of a diffuse ray.
    kBufferTypeDiffuseRayDirection: BufferType : 47;

    //! Optional - Buffer containing display resolution depth.
    kBufferTypeHiResDepth: BufferType : 48;

    //! Required either this or kBufferTypeDepth - Buffer containing linear depth.
    kBufferTypeLinearDepth: BufferType : 49;

    //! Optional - Bidirectional distortion field. 4 channels in normalized [0,1] pixel space. RG = distorted pixel to undistorted pixel displacement. BA = undistorted pixel to distorted pixel displacement.
    kBufferTypeBidirectionalDistortionField: BufferType : 50;

    //!Optional - Buffer containing particles or other similar transparent effects rendered into it instead of passing it as part of the input color
    kBufferTypeTransparencyLayer: BufferType : 51;

    //!Optional - Buffer to be used in addition to TransparencyLayer which allows 3-channels of Opacity versus 1-channel.
    //            In this case, TransparencyLayer represents Color (RcGcBc), TransparencyLayerOpacity represents alpha (RaGaBa)'
    kBufferTypeTransparencyLayerOpacity: BufferType : 52;

    //! Optional - Swapchain buffer to be presented
    kBufferTypeBackbuffer: BufferType : 53;

    //! Optional - Mask for pixels to skip warping
    kBufferTypeNoWarpMask: BufferType : 54;

    //! Optional - Color buffer after particles are drawn (for research purposes)
    kBufferTypeColorAfterParticles: BufferType : 55;

    //! Optional - Color buffer after transparent objects are drawn (for research purposes)
    kBufferTypeColorAfterTransparency: BufferType : 56;

    //! Optional - Color buffer after fog is drawn (for research purposes)
    kBufferTypeColorAfterFog: BufferType : 57;

    //! Optional - Subsurface scattering guide buffer
    kBufferTypeScreenSpaceSubsurfaceScatteringGuide: BufferType : 58;

    //! Optional - Color buffer before subsurface scattering (for research purposes)
    kBufferTypeColorBeforeScreenSpaceSubsurfaceScattering: BufferType : 59;

    //! Optional - Color buffer after subsurface scattering (for research purposes)
    kBufferTypeColorAfterScreenSpaceSubsurfaceScattering: BufferType : 60;

    //! Optional - Refraction guide buffer (for research purposes)
    kBufferTypeScreenSpaceRefractionGuide: BufferType : 61;

    //! Optional - Color buffer before refraction (for research purposes)
    kBufferTypeColorBeforeScreenSpaceRefraction: BufferType : 62;

    //! Optional - Color buffer after refraction (for research purposes)
    kBufferTypeColorAfterScreenSpaceRefraction: BufferType : 63;

    //! Optional - Depth of Field Buffer (for research purposes)
    kBufferTypeDepthOfFieldGuide: BufferType : 64;

    //! Optional - Color buffer before Depth of Field (for research purposes)
    kBufferTypeColorBeforeDepthOfField: BufferType : 65;

    //! Optional - Color buffer after Depth of Field (for research purposes)
    kBufferTypeColorAfterDepthOfField: BufferType : 66;

    //! Optional - Color buffer that overrides the alpha channel of kBufferTypeScalingOutputColor
    kBufferTypeScalingOutputAlpha: BufferType : 67;

    //! Optional buffer for responsivity mask
    kBufferTypeResponsivityMask: BufferType : 68;

    //! Optional - UI Alpha
    //! A 1 channel resource containing the alpha value of on-screen elements, between 0.0f and 1.0f inclusive.
    //!  Similar to kBufferTypeUIColorAndAlpha, but only the alpha channel for optimized run-time performance.
    kBufferTypeUIAlpha: BufferType : 69;

    //! Input color for neural-net "uplift" passes
    kBufferTypeUpliftInputColor: BufferType : 70;

    //! Output color for neural-net "uplift" passes
    //! May alias kBufferTypeUpliftInputColor (in-place uplift); the feature transitions appropriately.
    kBufferTypeUpliftOutputColor: BufferType : 71;

    //! Optional - 4-channel control mask consumed by uplift passes
    kBufferTypeUpliftControlMask: BufferType : 72;

    //! Features supported with this SDK
    //!
    //! IMPORTANT: Each feature must use a unique id
    //!
    Feature :: u32;

    //! Deep Learning Super Sampling
    kFeatureDLSS: Feature : 0;

    //! Real-Time Denoiser (removed)
    kFeatureNRD_INVALID: Feature : 1;

    //! NVIDIA Image Scaling
    kFeatureNIS: Feature : 2;

    //! Reflex
    kFeatureReflex: Feature : 3;

    //! PC Latency
    kFeaturePCL: Feature : 4;

    //! DeepDVC
    kFeatureDeepDVC: Feature : 5;

    kFeatureLatewarp: Feature : 6;

    //! DLSS Frame Generation
    kFeatureDLSS_G: Feature : 1000;

    //! DLSS Ray Reconstruction
    kFeatureDLSS_RR: Feature : 1001;

    kFeatureNvPerf: Feature : 1002;

    kFeatureDirectSR: Feature : 1003;

    kFeatureDLSS_NR: Feature : 1004;

    // ImGUI
    kFeatureImGUI: Feature : 9999;

    //! Common feature, NOT intended to be used directly
    kFeatureCommon: Feature : U32_MAX;

    //! Different levels for logging
    LogLevel :: enum u32 {
        eOff     :: 0;

        eDefault :: 1;

        eVerbose :: 2;

        eCount   :: 3;
    }

    //! Resource types
    ResourceType :: enum u8 {
        eTex2d         :: 0;
        eBuffer        :: 1;
        eCommandQueue  :: 2;
        eCommandBuffer :: 3;
        eCommandPool   :: 4;
        eFence         :: 5;
        eSwapchain     :: 6;
        eHostFence     :: 7;

        eUnknown       :: 8;
        eCount         :: 9;
    }

    //! Resource allocate information
    //!
    ResourceAllocationDesc :: struct {
        s_structType :: StructType.{0xbb57e5, 0x49a2, 0x4c23, .[0xa5, 0x19, 0xab, 0x92, 0x86, 0xe7, 0x40, 0x14]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Indicates the type of resource
        type:  ResourceType = .eTex2d;

        //! D3D12_RESOURCE_DESC/VkImageCreateInfo/VkBufferCreateInfo
        desc:  *void;

        //! Initial state as D3D12_RESOURCE_STATES or VkMemoryPropertyFlags
        state: u32 = 0;

        //! CD3DX12_HEAP_PROPERTIES or nullptr
        heap:  *void;
    }

    //! Subresource range information, for Vulkan resources
    //!
    //! {8D4C316C-D402-4524-89A7-14E79E638E3A}
    SubresourceRange :: struct {
        s_structType :: StructType.{0x8d4c316c, 0xd402, 0x4524, .[0x89, 0xa7, 0x14, 0xe7, 0x9e, 0x63, 0x8e, 0x3a]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Vulkan subresource aspectMask
        aspectMask:     u32;

        //! Vulkan subresource baseMipLevel
        baseMipLevel:   u32;

        //! Vulkan subresource levelCount
        levelCount:     u32;

        //! Vulkan subresource baseArrayLayer
        baseArrayLayer: u32;

        //! Vulkan subresource layerCount
        layerCount:     u32;
    }

    //! Native resource
    //!
    //! {3A9D70CF-2418-4B72-8391-13F8721C7261}
    Resource :: struct {
        s_structType :: StructType.{0x3a9d70cf, 0x2418, 0x4b72, .[0x83, 0x91, 0x13, 0xf8, 0x72, 0x1c, 0x72, 0x61]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Indicates the type of resource
        type:              ResourceType = .eTex2d;

        //! ID3D11Resource/ID3D12Resource/VkBuffer/VkImage
        native:            *void;

        //! vkDeviceMemory or nullptr
        memory:            *void;

        //! VkImageView/VkBufferView or nullptr
        view:              *void;

        //! State as D3D12_RESOURCE_STATES or VkImageLayout
        //!
        //! IMPORTANT: State is MANDATORY and needs to be correct when tagged resources are actually used.
        //!
        state:             u32 = U32_MAX;

        //! Width in pixels
        width:             u32;

        //! Height in pixels
        height:            u32;

        //! Native format
        nativeFormat:      u32;

        //! Number of mip-map levels
        mipLevels:         u32;

        //! Number of arrays
        arrayLayers:       u32;

        //! Virtual address on GPU (if applicable)
        gpuVirtualAddress: u64;

        //! VkImageCreateFlags
        flags:             u32;

        //! VkImageUsageFlags
        usage:             u32;

        //! Internal flags (bitfield) - do not modify
        InternalFlags :: enum u16 {
            eNone                 :: 0;

            eVulkanSwapChainImage :: 1;
        }

        internalFlags:     u16;

        //! Reserved for future use
        reserved:          u16;
    }

    //! Specifies life-cycle for the tagged resource
    //!
    //! IMPORTANT: Use 'eOnlyValidNow' and 'eValidUntilEvaluate' ONLY when really needed since it can result in wasting VRAM if SL ends up making unnecessary copies.
    //!
    //! If integrating features, like for example DLSS-G, which require tags to be 'eValidUntilPresent' please try to tag everything as 'eValidUntilPresent' first
    //! and only make modifications if upon visual inspection you notice that tags are corrupted when used during the Present frame call.
    ResourceLifecycle :: enum s32 {
        eOnlyValidNow       :: 0;

        eValidUntilPresent  :: 1;

        eValidUntilEvaluate :: 2;
    }

    //! Tagged resource
    //!
    //! {4C6A5AAD-B445-496C-87FF-1AF3845BE653}
    //! Extensions as part of the `next` ptr:
    //!     PrecisionInfo
    ResourceTag :: struct {
        s_structType :: StructType.{0x4c6a5aad, 0xb445, 0x496c, .[0x87, 0xff, 0x1a, 0xf3, 0x84, 0x5b, 0xe6, 0x53]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Resource description
        resource:  *Resource;

        //! Type of the tagged buffer
        type:      BufferType;

        //! The life-cycle for the tag, if resource is volatile a valid command buffer must be specified
        lifecycle: ResourceLifecycle;

        //! The area of the tagged resource to use (if using the entire resource leave as null)
        extent:    Extent;
    }

    //
    //! Precision info, optional extension for ResourceTag.
    //!
    //! {98F6E9BA-8D16-4831-A802-4D3B52FF26BF}
    //! Extensions as part of the `next` ptr:
    //!     ResourceTag
    PrecisionInfo :: struct {
        s_structType :: StructType.{0x98f6e9ba, 0x8d16, 0x4831, .[0xa8, 0x2, 0x4d, 0x3b, 0x52, 0xff, 0x26, 0xbf]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        // Formula used to convert the low-precision data to high-precision
        PrecisionFormula :: enum u32 {
            eNoTransform     :: 0;
            eLinearTransform :: 1;
        }

        conversionFormula: PrecisionFormula = .eNoTransform;
        bias:              float = 0.0;
        scale:             float = 1.0;
    }

    //! Resource allocation/deallocation callbacks
    //!
    //! Use these callbacks to gain full control over
    //! resource life cycle and memory allocation tracking.
    //!
    //! @param device - Device to be used (vkDevice or ID3D11Device or ID3D12Device)
    //!
    //! IMPORTANT: Textures must have the pixel shader resource
    //! and the unordered access view flags set
    PFun_ResourceAllocateCallback :: #type (desc: *ResourceAllocationDesc, device: *void) -> Resource #c_call #cpp_return_type_is_non_pod;
    PFun_ResourceReleaseCallback :: #type (resource: *Resource, device: *void) -> void #c_call;

    //! Log type
    LogType :: enum u32 {
        eInfo  :: 0;

        eWarn  :: 1;
        eError :: 2;

        eCount :: 3;
    }

    //! Logging callback
    //!
    //! Use these callbacks to track messages posted in the log.
    //! If any of the SL methods returns false use eLogTypeError
    //! type to track down what went wrong and why.
    PFun_LogMessageCallback :: #type (type: LogType, msg: *u8) -> void #c_call;

    APIError :: struct {
        union {
            hres:  HRESULT;
            vkRes: SL_VKResult;
        }
    }

    //! Returns an error returned by DXGI or Vulkan API calls 'vkQueuePresentKHR' and 'vkAcquireNextImageKHR'
    PFunOnAPIErrorCallback :: #type (lastError: *APIError) -> void #c_call;

    //! Optional flags
    PreferenceFlags :: enum_flags u64 {
        eDisableCLStateTracking       :: 0x1;

        eDisableDebugText             :: 0x2;

        eUseManualHooking             :: 0x4;

        eAllowOTA                     :: 0x8;

        eBypassOSVersionCheck         :: 0x10;

        eUseDXGIFactoryProxy          :: 0x20;

        eLoadDownloadedPlugins        :: 0x40;

        eUseFrameBasedResourceTagging :: 0x80;

        eAll                          :: 0xff;
    }

    //! Application preferences
    //!
    //! {1CA10965-BF8E-432B-8DA1-6716D879FB14}
    Preferences :: struct {
        s_structType :: StructType.{0x1ca10965, 0xbf8e, 0x432b, .[0x8d, 0xa1, 0x67, 0x16, 0xd8, 0x79, 0xfb, 0x14]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Optional - In non-production builds it is useful to enable debugging console window
        showConsole         := false;

        //! Optional - Various logging levels
        logLevel:           LogLevel = .eDefault;

        //! Optional - Absolute paths to locations where to look for plugins, first path in the list has the highest priority
        pathsToPlugins:     **s16;

        //! Optional - Number of paths to search
        numPathsToPlugins:  u32 = 0;

        //! Optional - Absolute path to location where logs and other data should be stored
        //!
        //! NOTE: Set this to nullptr in order to disable logging to a file
        pathToLogsAndData:  *s16;

        //! Optional - Allows resource allocation tracking on the host side
        allocateCallback:   PFun_ResourceAllocateCallback;

        //! Optional - Allows resource deallocation tracking on the host side
        releaseCallback:    PFun_ResourceReleaseCallback;

        //! Optional - Allows log message tracking including critical errors if they occur
        logMessageCallback: PFun_LogMessageCallback;

        //! Optional - Flags used to enable or disable advanced options
        flags:              PreferenceFlags = .eDisableCLStateTracking | .eAllowOTA | .eLoadDownloadedPlugins;

        //! Required - Features to load (assuming appropriate plugins are found), if not specified NO features will be loaded by default
        featuresToLoad:     *Feature;

        //! Required - Number of features to load, only used when list is not a null pointer
        numFeaturesToLoad:  u32;

        //! Optional - Id provided by NVIDIA, if not specified then engine type and version are required
        applicationId:      u32;

        //! Optional - Type of the rendering engine used, if not specified then applicationId is required
        engine:             EngineType = .eCustom;

        //! Optional - Version of the rendering engine used
        engineVersion:      *u8;

        //! Optional - GUID (like for example 'a0f57b54-1daf-4934-90ae-c4035c19df04')
        projectId:          *u8;

        //! Optional - Which rendering API host is planning to use
        //!
        //! NOTE: To ensure correct `slGetFeatureRequirements` behavior please specify if planning to use Vulkan.
        renderAPI:          RenderAPI = .eD3D12;
    }

    //! Frame tracking handle
    //!
    //! IMPORTANT: Use slGetNewFrameToken to obtain unique instance
    //!
    //! {830A0F35-DB84-4171-A804-59B206499B18}
    FrameToken :: struct {
        s_structType :: StructType.{0x830a0f35, 0xdb84, 0x4171, .[0xa8, 0x4, 0x59, 0xb2, 0x6, 0x49, 0x9b, 0x18]};
        vtable: *FrameToken_VTable;
        using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};
    }

    FrameToken_VTable :: struct #type_info_none {
        operator_uint32_t: (this: *FrameToken) -> u32 #cpp_method;
    }

    FrameToken_operator_uint32_t :: inline (this: *FrameToken) -> u32 { return this.vtable.operator_uint32_t(this); }

    //! Handle for the unique viewport
    //!
    //! {171B6435-9B3C-4FC8-9994-FBE52569AAA4}
    ViewportHandle :: struct {
        s_structType :: StructType.{0x171b6435, 0x9b3c, 0x4fc8, .[0x99, 0x94, 0xfb, 0xe5, 0x25, 0x69, 0xaa, 0xa4]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        value: u32 = U32_MAX;
    }

    //! Specifies feature requirement flags
    //!
    FeatureRequirementFlags :: enum_flags u32 {
        eD3D11Supported             :: 0x1;
        eD3D12Supported             :: 0x2;
        eVulkanSupported            :: 0x4;

        eVSyncOffRequired           :: 0x8;

        eHardwareSchedulingRequired :: 0x10;

        eAll                        :: 0x1f;
    }

    //! Specifies feature requirements
    //!
    //! {66714097-AC6D-4BC6-8915-1E0F55A6B61F}
    FeatureRequirements :: struct {
        s_structType :: StructType.{0x66714097, 0xac6d, 0x4bc6, .[0x89, 0x15, 0x1e, 0xf, 0x55, 0xa6, 0xb6, 0x1f]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion2};

        //! Various Flags
        flags:                          FeatureRequirementFlags;

        //! Feature will create this many CPU threads
        maxNumCPUThreads:               u32;

        //! Feature supports only this many viewports
        maxNumViewports:                u32;

        //! Required buffer tags
        numRequiredTags:                u32;
        requiredTags:                   *BufferType;

        //! OS and Driver versions
        osVersionDetected:              Version;
        osVersionRequired:              Version;
        driverVersionDetected:          Version;
        driverVersionRequired:          Version;

        //! Command queues
        vkNumComputeQueuesRequired:     u32;
        vkNumGraphicsQueuesRequired:    u32;

        //! Device extensions
        vkNumDeviceExtensions:          u32;
        vkDeviceExtensions:             **u8;

        //! Instance extensions
        vkNumInstanceExtensions:        u32;
        vkInstanceExtensions:           **u8;

        //! 1.2 features
        //!
        //! NOTE: Use getVkPhysicalDeviceVulkan12Features from sl_helpers_vk.h
        vkNumFeatures12:                u32;
        vkFeatures12:                   **u8;

        //! 1.3 features
        //!
        //! NOTE: Use getVkPhysicalDeviceVulkan13Features from sl_helpers_vk.h
        vkNumFeatures13:                u32;
        vkFeatures13:                   **u8;

        //! Vulkan optical flow feature
        vkNumOpticalFlowQueuesRequired: u32;
    }

    //! Specifies feature's version
    //!
    //! {6D5B51F0-076B-486D-9995-5A561043F5C1}
    FeatureVersion :: struct {
        s_structType :: StructType.{0x6d5b51f0, 0x76b, 0x486d, .[0x99, 0x95, 0x5a, 0x56, 0x10, 0x43, 0xf5, 0xc1]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! SL version
        versionSL:  Version;

        //! NGX version (if feature is using NGX, null otherwise)
        versionNGX: Version;
    }

    //! Specifies either DXGI adapter or VK physical device
    //!
    //! {0677315F-A746-4492-9F42-CB6142C9C3D4}
    AdapterInfo :: struct {
        s_structType :: StructType.{0x677315f, 0xa746, 0x4492, .[0x9f, 0x42, 0xcb, 0x61, 0x42, 0xc9, 0xc3, 0xd4]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Locally unique identifier
        deviceLUID:            *u8;

        //! Size in bytes
        deviceLUIDSizeInBytes: u32;

        //! Vulkan Specific, if specified LUID will be ignored
        vkPhysicalDevice:      *void;
    }

    //! A simple array wrapper designed for safe use across DLL boundaries.
    //! Since different DLLs may use different memory allocators, this class
    //! relies on an IAllocator pointer to ensure that memory is allocated
    //! and freed consistently within the same runtime.
    IAllocator :: struct {
        vtable: *IAllocator_VTable;
    }
    IAllocator_VTable :: struct #type_info_none {
        Destructor: (this: *IAllocator, flags: Msvc_Destructor_Flags = .NONE) -> void #cpp_method;
        allocate: (this: *IAllocator, nBytes: u32) -> *void #cpp_method;
        free: (this: *IAllocator, p: *void) -> void #cpp_method;
    }

    IAllocator_Destructor :: inline (this: *IAllocator, flags: Msvc_Destructor_Flags = .NONE) { this.vtable.Destructor(this, flags); }
    IAllocator_allocate :: inline (this: *IAllocator, nBytes: u32) -> *void { return this.vtable.allocate(this, nBytes); }
    IAllocator_free :: inline (this: *IAllocator, p: *void) { this.vtable.free(this, p); }

    vtable :: (obj: *IAllocator) -> *IAllocator_VTable { return obj.vtable; }


    Array :: struct(T: Type) {
        m_pData:      *T;
        m_size:       u32;

        // the allocator that was used to allocate memory
        m_pAllocator: *IAllocator;
    }

    //! Hot-key which should be used instead of custom message for PC latency marker
    PCLHotKey :: enum s16 {
        eUsePingMessage :: 0;
        eVK_F13         :: 124;
        eVK_F14         :: 125;
        eVK_F15         :: 126;
    }

    // {cfa32f9b-023c-420e-9056-6832b74f89b4}
    PCLOptions :: struct {
        s_structType :: StructType.{0xcfa32f9b, 0x023c, 0x420e, .[0x90, 0x56, 0x68, 0x32, 0xb7, 0x4f, 0x89, 0xb4]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specifies the hot-key which should be used instead of custom message for PC latency marker
        //! Possible values: VK_F13, VK_F14, VK_F15
        virtualKey: PCLHotKey = .eUsePingMessage;

        //! ThreadID for PCL messages
        idThread:   u32 = 0;
    }

    // {cfa32f9b-023c-420e-9056-6832b74f89b5}
    PCLState :: struct {
        s_structType :: StructType.{0xcfa32f9b, 0x023c, 0x420e, .[0x90, 0x56, 0x68, 0x32, 0xb7, 0x4f, 0x89, 0xb5]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specifies PCL Windows message id (if PCLOptions::virtualKey is 0)
        statsWindowMessage: u32;
    }

    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
    PCLMarker :: enum u32 {
        eSimulationStart                 :: 0;
        eSimulationEnd                   :: 1;
        eRenderSubmitStart               :: 2;
        eRenderSubmitEnd                 :: 3;
        ePresentStart                    :: 4;
        ePresentEnd                      :: 5;

        eTriggerFlash                    :: 7;
        ePCLatencyPing                   :: 8;
        eOutOfBandRenderSubmitStart      :: 9;
        eOutOfBandRenderSubmitEnd        :: 10;
        eOutOfBandPresentStart           :: 11;
        eOutOfBandPresentEnd             :: 12;
        eControllerInputSample           :: 13;
        eDeltaTCalculation               :: 14;
        eLateWarpPresentStart            :: 15;
        eLateWarpPresentEnd              :: 16;
        eCameraConstructed               :: 17;
        eLateWarpRenderSubmitStart       :: 18;
        eLateWarpRenderSubmitEnd         :: 19;
        eVendorInternalAsyncPresentStart :: 20;
        eVendorInternalAsyncPresentEnd   :: 21;
        eNumPresentsInBatch              :: 22;

        eMaximum                         :: 23;
    }

    // {cfa32f9b-023c-420e-9056-6832b74f89b6}
    PCLHelper :: struct {
        s_structType :: StructType.{0xcfa32f9b, 0x023c, 0x420e, .[0x90, 0x56, 0x68, 0x32, 0xb7, 0x4f, 0x89, 0xb6]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        marker: PCLMarker;
    }

    ReflexMode :: enum s32 {
        eOff                 :: 0;
        eLowLatency          :: 1;
        eLowLatencyWithBoost :: 2;

        eCount               :: 3;
        ReflexMode_eCount :: eCount;
    }

    // {F03AF81A-6D0B-4902-A651-C4965E215434}
    ReflexOptions :: struct {
        s_structType :: StructType.{0xf03af81a, 0x6d0b, 0x4902, .[0xa6, 0x51, 0xc4, 0x96, 0x5e, 0x21, 0x54, 0x34]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specifies which mode should be used
        mode:                 ReflexMode = .eOff;

        //! Specifies if frame limiting (FPS cap) is enabled (0 to disable, microseconds otherwise).
        //! One benefit of using Reflex's FPS cap over other implementations is the driver would be aware and can provide better optimizations.
        //! This setting is independent of ReflexOptions::mode; it can even be used with mode == ReflexMode::eOff.
        //! The value is used each time you call slReflexSetOptions/slSetData, make sure to initialize when changing one of the other Reflex options during frame limiting.
        //! It is overridden (ignored) by frameLimitUs if set in sl.reflex.json in non-production builds.
        frameLimitUs:         u32 = 0;

        //! This should only be enabled in specific scenarios with subtle caveats.
        //! Most integrations should leave unset unless advised otherwise by the Reflex team
        useMarkersToOptimize  := false;

        //! Specifies the hot-key which should be used instead of custom message for PC latency marker
        //! Possible values: VK_F13, VK_F14, VK_F15
        virtualKey:           u16 = 0;

        //! ThreadID for PCL Stats messages
        //! Most integrations should leave unset unless advised otherwise by the Reflex team
        idThread:             u32 = 0;
    }

    // {0D569B37-A1C8-4453-BE4D-40F4DE57952B}
    ReflexReport :: struct {
        s_structType :: StructType.{0xd569b37, 0xa1c8, 0x4453, .[0xbe, 0x4d, 0x40, 0xf4, 0xde, 0x57, 0x95, 0x2b]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Various latency related stats
        frameID:                u64;
        inputSampleTime:        u64;
        simStartTime:           u64;
        simEndTime:             u64;
        renderSubmitStartTime:  u64;
        renderSubmitEndTime:    u64;
        presentStartTime:       u64;
        presentEndTime:         u64;
        driverStartTime:        u64;
        driverEndTime:          u64;
        osRenderQueueStartTime: u64;
        osRenderQueueEndTime:   u64;
        gpuRenderStartTime:     u64;
        gpuRenderEndTime:       u64;
        gpuActiveRenderTimeUs:  u32;
        gpuFrameTimeUs:         u32;
    }

    // {68bb0632-5e1c-402b-899d-b49f633c56c2}
    ReflexReport2 :: struct {
        s_structType :: StructType.{0x68bb0632, 0x5e1c, 0x402b, .[0x89, 0x9d, 0xb4, 0x9f, 0x63, 0x3c, 0x56, 0xc2]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Various latency related stats
        cameraConstructedTime:  u64;
        crossAdapterCopyTimeUs: u32;
    }

    //! IMPORTANT: This struct cannot have new members because it is arrayed by ReflexState.
    kReflexFrameReportCount: s32 : 64;

    // {F0BB5985-DAF9-4728-B2FD-AE80A2BD7989}
    ReflexState :: struct {
        s_structType :: StructType.{0xf0bb5985, 0xdaf9, 0x4728, .[0xb2, 0xfd, 0xae, 0x80, 0xa2, 0xbd, 0x79, 0x89]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion2};

        //! Specifies if low-latency mode is available or not
        lowLatencyAvailable             := false;

        //! Specifies if the frameReport below contains valid data or not
        latencyReportAvailable          := false;

        //! Specifies low latency Windows message id (if ReflexOptions::virtualKey is 0)
        statsWindowMessage:             u32;

        //! Reflex report per frame
        frameReport:                    [64] ReflexReport;

        //! Specifies ownership of flash indicator toggle (true = driver, false = application)
        flashIndicatorDriverControlled  := false;

        // kStructVersion2
        //! Reflex report per frame
        frameReport2:                   [64] ReflexReport2;
    }

    // {c83cbb02-b4e2-4260-9ca2-d0c3de3a9684}
    ReflexCameraData :: struct {
        s_structType :: StructType.{0xc83cbb02, 0xb4e2, 0x4260, .[0x9c, 0xa2, 0xd0, 0xc3, 0xde, 0x3a, 0x96, 0x84]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};
        worldToViewMatrix:             float4x4;
        viewToClipMatrix:              float4x4;
        prevRenderedWorldToViewMatrix: float4x4;
        prevRenderedViewToClipMatrix:  float4x4;
    }

    // {8b960090-a807-4c85-b02f-1069950d066c}
    ReflexPredictedCameraData :: struct {
        s_structType :: StructType.{0x8b960090, 0xa807, 0x4c85, .[0xb0, 0x2f, 0x10, 0x69, 0x95, 0x0d, 0x06, 0x6c]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};
        predictedWorldToViewMatrix: float4x4;
        predictedViewToClipMatrix:  float4x4;
    }

    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
    MarkerUnderlying :: u32;

    // {E268B3DC-F963-4C37-9776-AF048E132621}
    ReflexHelper :: struct {
        s_structType :: StructType.{0xe268b3dc, 0xf963, 0x4c37, .[0x97, 0x76, 0xaf, 0x4, 0x8e, 0x13, 0x26, 0x21]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        // May be kReflexMarkerSleep which is not a valid PCLMarker value
        marker: MarkerUnderlying;
    }

    DLSSMode :: enum u32 {
        eOff              :: 0;
        eMaxPerformance   :: 1;
        eBalanced         :: 2;
        eMaxQuality       :: 3;
        eUltraPerformance :: 4;
        eUltraQuality     :: 5;
        eDLAA             :: 6;
        eCount            :: 7;
    }

    DLSSPreset :: enum u32 {
        eDefault :: 0;

        ePresetE :: 5;
        ePresetF :: 6;
        ePresetG :: 7;
        ePresetH :: 8;
        ePresetI :: 9;
        ePresetJ :: 10;
        ePresetK :: 11;
        ePresetL :: 12;
        ePresetM :: 13;
        ePresetN :: 14;
        ePresetO :: 15;

        eCount   :: 16;
    }

    // {6AC826E4-4C61-4101-A92D-638D421057B8}
    DLSSOptions :: struct {
        s_structType :: StructType.{0x6ac826e4, 0x4c61, 0x4101, .[0xa9, 0x2d, 0x63, 0x8d, 0x42, 0x10, 0x57, 0xb8]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion3};

        //! Specifies which mode should be used
        mode:                   DLSSMode = .eOff;

        //! Specifies output (final) target width
        outputWidth:            u32 = INVALID_UINT;

        //! Specifies output (final) target height
        outputHeight:           u32 = INVALID_UINT;

        //! Specifies sharpening level in range [0,1] this is a deprecated field
        sharpness:              float = 0.0;

        //! Specifies pre-exposure value
        preExposure:            float = 1.0;

        //! Specifies exposure scale value
        exposureScale:          float = 1.0;

        //! Specifies if tagged color buffers are full HDR or not (DLSS in HDR pipeline or not)
        colorBuffersHDR:        Boolean = .eTrue;

        //! Specifies if indicator on screen should invert axis
        indicatorInvertAxisX:   Boolean = .eFalse;

        //! Specifies if indicator on screen should invert axis
        indicatorInvertAxisY:   Boolean = .eFalse;

        //! Presets
        dlaaPreset:             DLSSPreset = .eDefault;
        qualityPreset:          DLSSPreset = .eDefault;
        balancedPreset:         DLSSPreset = .eDefault;
        performancePreset:      DLSSPreset = .eDefault;
        ultraPerformancePreset: DLSSPreset = .eDefault;
        ultraQualityPreset:     DLSSPreset = .eDefault;

        //! Specifies if the setting for AutoExposure is used
        useAutoExposure:        Boolean = .eFalse;

        //! Whether or not the alpha channel should be upscaled (if false, only RGB is upscaled)
        //! Enabling alpha upscaling may impact performance
        alphaUpscalingEnabled:  Boolean = .eFalse;
    }

    //! Returned by DLSS plugin
    //!
    //! {EF1D0957-FD58-4DF7-B504-8B69D8AA6B76}
    DLSSOptimalSettings :: struct {
        s_structType :: StructType.{0xef1d0957, 0xfd58, 0x4df7, .[0xb5, 0x4, 0x8b, 0x69, 0xd8, 0xaa, 0x6b, 0x76]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specifies render area width
        optimalRenderWidth:  u32;

        //! Specifies render area height
        optimalRenderHeight: u32;

        //! Specifies the optimal sharpness value
        optimalSharpness:    float;

        //! Specifies minimal render area width
        renderWidthMin:      u32;

        //! Specifies minimal render area height
        renderHeightMin:     u32;

        //! Specifies maximal render area width
        renderWidthMax:      u32;

        //! Specifies maximal render area height
        renderHeightMax:     u32;
    }

    //! Returned by DLSS plugin
    //!
    //! {9366B056-8C01-463C-BB91-E68782636CE9}
    DLSSState :: struct {
        s_structType :: StructType.{0x9366b056, 0x8c01, 0x463c, .[0xbb, 0x91, 0xe6, 0x87, 0x82, 0x63, 0x6c, 0xe9]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specified the amount of memory expected to be used
        estimatedVRAMUsageInBytes: u64;
    }

    NISMode :: enum u32 {
        eOff     :: 0;
        eScaler  :: 1;
        eSharpen :: 2;
        eCount   :: 3;
    }

    NISHDR :: enum u32 {
        eNone   :: 0;
        eLinear :: 1;
        ePQ     :: 2;
        eCount  :: 3;
    }

    // {676610E5-9674-4D3A-9C8A-F495D01B36F3}
    NISOptions :: struct {
        s_structType :: StructType.{0x676610e5, 0x9674, 0x4d3a, .[0x9c, 0x8a, 0xf4, 0x95, 0xd0, 0x1b, 0x36, 0xf3]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specifies which mode should be used
        mode:      NISMode = .eScaler;

        //! Specifies which hdr mode should be used
        hdrMode:   NISHDR = .eNone;

        //! Specifies sharpening level in range [0,1]
        sharpness: float = 0.0;
    }

    //! Returned by the NIS plugin
    //!
    // {71AB4FD0-D959-4C2A-AF69-ED4850BD4E3D}
    NISState :: struct {
        s_structType :: StructType.{0x71ab4fd0, 0xd959, 0x4c2a, .[0xaf, 0x69, 0xed, 0x48, 0x50, 0xbd, 0x4e, 0x3d]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specified the amount of memory expected to be used
        estimatedVRAMUsageInBytes: u64;
    }

    DLSSDPreset :: enum u32 {
        eDefault :: 0;

        ePresetD :: 4;
        ePresetE :: 5;
        ePresetF :: 6;
        ePresetG :: 7;
        ePresetH :: 8;
        ePresetI :: 9;
        ePresetJ :: 10;
        ePresetK :: 11;
        ePresetL :: 12;
        ePresetM :: 13;
        ePresetN :: 14;
        ePresetO :: 15;

        eCount   :: 16;
    }

    DLSSDNormalRoughnessMode :: enum u32 {
        eUnpacked :: 0;
        ePacked   :: 1;

        eCount    :: 2;
    }

    // {0AD87504-774E-4BF3-9633-A44D1F7F9CB8}
    DLSSDOptions :: struct {
        s_structType :: StructType.{0x0ad87504, 0x774e, 0x4bf3, .[0x96, 0x33, 0xa4, 0x4d, 0x1f, 0x7f, 0x9c, 0xb8]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion3};

        //! Specifies which mode should be used
        mode:                   DLSSMode = .eOff;

        //! Specifies output (final) target width
        outputWidth:            u32 = INVALID_UINT;

        //! Specifies output (final) target height
        outputHeight:           u32 = INVALID_UINT;

        //! Specifies sharpening level in range [0,1]
        sharpness:              float = 0.0;

        //! Specifies pre-exposure value
        preExposure:            float = 1.0;

        //! Specifies exposure scale value
        exposureScale:          float = 1.0;

        //! Specifies if tagged color buffers are full HDR or not (DLSS in HDR pipeline or not)
        colorBuffersHDR:        Boolean = .eTrue;

        //! Specifies if indicator on screen should invert axis
        indicatorInvertAxisX:   Boolean = .eFalse;

        //! Specifies if indicator on screen should invert axis
        indicatorInvertAxisY:   Boolean = .eFalse;

        //! Specifies which mode should be used for roughness resource
        normalRoughnessMode:    DLSSDNormalRoughnessMode = .eUnpacked;

        //! Specifies matrix transformation from the world space to the camera view space.
        worldToCameraView:      float4x4;

        //! Specifies matrix transformation from the camera view space to the world space.
        //! cameraViewToWorld = worldToCameraView.inverse()
        cameraViewToWorld:      float4x4;

        //! Whether or not the alpha channel should be upscaled (if false, only RGB is upscaled)
        //! Enabling alpha upscaling may impact performance
        alphaUpscalingEnabled:  Boolean = .eFalse;

        //! Presets
        dlaaPreset:             DLSSDPreset = .eDefault;
        qualityPreset:          DLSSDPreset = .eDefault;
        balancedPreset:         DLSSDPreset = .eDefault;
        performancePreset:      DLSSDPreset = .eDefault;
        ultraPerformancePreset: DLSSDPreset = .eDefault;
        ultraQualityPreset:     DLSSDPreset = .eDefault;
    }

    //! Returned by DLSSD plugin
    //!
    //! {FBD0C637-A28F-41F2-BC91-B421FAEE8E1E}
    DLSSDOptimalSettings :: struct {
        s_structType :: StructType.{0xfbd0c637, 0xa28f, 0x41f2, .[0xbc, 0x91, 0xb4, 0x21, 0xfa, 0xee, 0x8e, 0x1e]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specifies render area width
        optimalRenderWidth:  u32;

        //! Specifies render area height
        optimalRenderHeight: u32;

        //! Specifies the optimal sharpness value
        optimalSharpness:    float;

        //! Specifies minimal render area width
        renderWidthMin:      u32;

        //! Specifies minimal render area height
        renderHeightMin:     u32;

        //! Specifies maximal render area width
        renderWidthMax:      u32;

        //! Specifies maximal render area height
        renderHeightMax:     u32;
    }

    //! Returned by DLSSD plugin
    //!
    //! {71873C14-F8CA-4767-9EAF-3B4393EA98FA}
    DLSSDState :: struct {
        s_structType :: StructType.{0x71873c14, 0xf8ca, 0x4767, .[0x9e, 0xaf, 0x3b, 0x43, 0x93, 0xea, 0x98, 0xfa]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specified the amount of memory expected to be used
        estimatedVRAMUsageInBytes: u64;
    }

    DLSSGMode :: enum u32 {
        eOff     :: 0;
        eOn      :: 1;
        eAuto    :: 2;
        eDynamic :: 3;
        eCount   :: 4;
    }

    DLSSGFlags :: enum_flags u32 {
        eShowOnlyInterpolatedFrame     :: 0x1;
        eDynamicResolutionEnabled      :: 0x2;
        eRequestVRAMEstimate           :: 0x4;
        eRetainResourcesWhenOff        :: 0x8;
        eEnableFullscreenMenuDetection :: 0x10;

        eAll                           :: 0x1f;
    }

    DLSSGQueueParallelismMode :: enum u32 {
        eBlockPresentingClientQueue :: 0;

        eBlockNoClientQueues        :: 1;
        eCount                      :: 2;
    }

    // {FAC5F1CB-2DFD-4F36-A1E6-3A9E865256C5}
    DLSSGOptions :: struct {
        s_structType :: StructType.{0xfac5f1cb, 0x2dfd, 0x4f36, .[0xa1, 0xe6, 0x3a, 0x9e, 0x86, 0x52, 0x56, 0xc5]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion5};

        //! Specifies which mode should be used.
        mode:                             DLSSGMode = .eOff;

        //! Number of frames to generate inbetween fully rendered frames. Cannot exceed DLSSGState::numFramesToGenerateMax.
        //!     For 2x frame multiplier, numFramesToGenerate is 1.
        //!     For 3x frame multiplier, numFramesToGenerate is 2.
        //!     For 4x frame multiplier, numFramesToGenerate is 3.
        numFramesToGenerate:              u32 = 1;

        //! Optional - Flags used to enable or disable certain functionality
        flags:                            DLSSGFlags;

        //! Optional - Dynamic resolution optimal width (used only if eDynamicResolutionEnabled is set)
        dynamicResWidth:                  u32;

        //! Optional - Dynamic resolution optimal height (used only if eDynamicResolutionEnabled is set)
        dynamicResHeight:                 u32;

        //! Optional - Expected number of buffers in the swap-chain
        numBackBuffers:                   u32;

        //! Optional - Expected width of the input render targets (depth, motion-vector buffers etc)
        mvecDepthWidth:                   u32;

        //! Optional - Expected height of the input render targets (depth, motion-vector buffers etc)
        mvecDepthHeight:                  u32;

        //! Optional - Expected width of the back buffers in the swap-chain
        colorWidth:                       u32;

        //! Optional - Expected height of the back buffers in the swap-chain
        colorHeight:                      u32;

        //! Optional - Indicates native format used for the swap-chain back buffers
        colorBufferFormat:                u32;

        //! Optional - Indicates native format used for eMotionVectors
        mvecBufferFormat:                 u32;

        //! Optional - Indicates native format used for eDepth
        depthBufferFormat:                u32;

        //! Optional - Indicates native format used for eHUDLessColor
        hudLessBufferFormat:              u32;

        //! Optional - Indicates native format used for eUIColorAndAlpha
        uiBufferFormat:                   u32;

        //! Optional - if specified DLSSG will return any errors which occur when calling underlying API (DXGI or Vulkan)
        onErrorCallback:                  PFunOnAPIErrorCallback;

        // kStructVersion2
        bReserved15:                      Boolean = .eInvalid;

        // kStructVersion3
        //! Optional - determines the level of client and DLSSG queue parallelism to use for performance gain - must be same for all viewports.
        queueParallelismMode:             DLSSGQueueParallelismMode;

        // kStructVersion4
        //! Optional - if true, DLSSG will allocate a codepath that supports interpolating 'HUDless' and 'UI Color & Alpha' separately than the Color Backbuffer.
        //!            this property can be overridden by Nvidia App. See the programming guide for more details.
        enableUserInterfaceRecomposition: Boolean = .eFalse;

        // kStructVersion5
        //! Optional - Target frame rate for dynamic frame generation when enabled.
        //!            If set to 0.0f (default), auto-detects the display refresh rate.
        dynamicTargetFrameRate:           float;
    }

    //! IMPORTANT: New members go here or if optional can be chained in a new struct, see sl_struct.h for details
    DLSSGStatus :: enum_flags u32 {
        eOk                                     :: 0x0;

        eFailResolutionTooLow                   :: 0x1;

        eFailReflexNotDetectedAtRuntime         :: 0x2;

        eFailHDRFormatNotSupported              :: 0x4;

        eFailCommonConstantsInvalid             :: 0x8;

        eFailGetCurrentBackBufferIndexNotCalled :: 0x10;

        eReserved5                              :: 0x20;

        eAll                                    :: 0x3f;
    }

    // {CC8AC8E1-A179-44F5-97FA-E74112F9BC61}
    DLSSGState :: struct {
        s_structType :: StructType.{0xcc8ac8e1, 0xa179, 0x44f5, .[0x97, 0xfa, 0xe7, 0x41, 0x12, 0xf9, 0xbc, 0x61]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion4};

        //! Specifies the amount of memory expected to be used
        estimatedVRAMUsageInBytes:                       u64;

        //! Specifies current status of DLSS-G
        status:                                          DLSSGStatus;

        //! Specifies minimum supported dimension
        minWidthOrHeight:                                u32;

        //! Number of frames presented since the last 'slDLSSGGetState' call
        numFramesActuallyPresented:                      u32;

        // kStructVersion2
        //! The maximum number of interpolated frames the current system can generate per real frame.
        //! This value represents the upper bound for 'numFramesToGenerate'.
        //! Examples:
        //!     - On devices supporting up to a 2x multiplier: numFramesToGenerateMax is 1.
        //!     - On devices supporting up to a 6x multiplier: numFramesToGenerateMax is 5.
        numFramesToGenerateMax:                          u32;

        //! Reserved for future use, do not use
        bReserved4:                                      Boolean;

        //! Hint to the application to display VSync support in the user interface
        bIsVsyncSupportAvailable:                        Boolean;

        //! SL client must wait on SL DLSS-G plugin-internal fence and associated value, before it can modify or destroy the tagged resources input
        //! to DLSS-G enabled for the corresponding previously presented frame on a non-presenting queue.
        //! If modified on client's presenting queue, then it's recommended but not required.
        //! However, if DLSSGQueueParallelismMode::eBlockNoClientQueues is set, then it's always required.
        //! It must call slDLSSGGetState on the present thread to retrieve the fence value for the inputs consumed by FG, on which client would
        //! wait in the frame it would modify those inputs.
        inputsProcessingCompletionFence:                 *void;
        lastPresentInputsProcessingCompletionFenceValue: u64;

        // kStructVersion4
        //! Whether or not Dynamic Multi Frame Generation (DLSSGMode::eDynamic) is
        //! supported
        bIsDynamicMFGSupported:                          Boolean;
    }

    DeepDVCMode :: enum u32 {
        eOff   :: 0;
        eOn    :: 1;
        eCount :: 2;
    }

    // {23288AAD-7E7E-BE2A-916F-27DA30A3046B}
    DeepDVCOptions :: struct {
        s_structType :: StructType.{0x23288aad, 0x7e7e, 0xbe2a, .[0x91, 0x67, 0x27, 0xda, 0x30, 0xa3, 0x04, 0x6b]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specifies which mode should be used
        mode:            DeepDVCMode = .eOff;

        //! Specifies intensity level in range [0,1]. Default 0.5
        intensity:       float = 0.5;

        //! Specifies saturation boost in range [0,1]. Default 0.25
        saturationBoost: float = 0.25;
    }

    //! Returned by the DeepDVC plugin
    //!
    // {934FD3D3-B34C-70A7-A139-F19FE04D91D3}
    DeepDVCState :: struct {
        s_structType :: StructType.{0x934fd3d3, 0xb34c, 0x70a7, .[0xa1, 0x39, 0xf1, 0x9f, 0xe0, 0x4d, 0x91, 0xd3]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specified the amount of memory expected to be used
        estimatedVRAMUsageInBytes: u64;
    }

    DirectSROptimizationType :: enum u32 {
        eBalanced        :: 0;
        eHighQuality     :: 1;
        eMaxQuality      :: 2;
        eHighPerformance :: 3;
        eMaxPerformance  :: 4;
        ePowerSaving     :: 5;
        eMaxPowerSaving  :: 6;

        eCount           :: 7;
    }

    DirectSRVariantFlags :: enum u32 {
        eNone                         :: 0;
        eSupportsExposureScaleTexture :: 1;
        eSupportsIgnoreHistoryMask    :: 2;
        eNative                       :: 4;
        eSupportsReactiveMask         :: 8;
        eSupportsSharpness            :: 16;
        eDisallowsRegionOffsets       :: 32;

        eAll                          :: 63;
    }

    // {1AD87504-774E-4BF3-9633-A44D1F7F9CB8}
    DirectSROptions :: struct {
        s_structType :: StructType.{0x1ad87504, 0x774e, 0x4bf3, .[0x96, 0x33, 0xa4, 0x4d, 0x1f, 0x7f, 0x9c, 0xb8]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        // DirectSR variant index as enumerated
        variantIndex:    u32;

        // D3D12 command queue to execute work on
        pCommandQueue:   *ID3D12CommandQueue;

        //! Specifies which mode should be used
        optType:         DirectSROptimizationType;

        //! Specifies output (final) target width
        outputWidth:     u32 = INVALID_UINT;

        //! Specifies output (final) target height
        outputHeight:    u32 = INVALID_UINT;

        //! Specifies sharpening level in range [0,1]
        sharpness:       float = 0.0;

        //! Specifies pre-exposure value
        preExposure:     float = 1.0;

        //! Specifies exposure scale value
        exposureScale:   float = 1.0;

        //! Specifies if tagged color buffers are full HDR or not (DLSS in HDR pipeline or not)
        colorBuffersHDR: Boolean = .eTrue;
    }

    //! Returned by DirectSR plugin
    //!
    //! {1BD0C637-A28F-41F2-BC91-B421FAEE8E1E}
    DirectSROptimalSettings :: struct {
        s_structType :: StructType.{0x1bd0c637, 0xa28f, 0x41f2, .[0xbc, 0x91, 0xb4, 0x21, 0xfa, 0xee, 0x8e, 0x1e]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};

        //! Specifies render area width
        optimalRenderWidth:  u32;

        //! Specifies render area height
        optimalRenderHeight: u32;

        //! Specifies minimal render area width
        renderWidthMin:      u32;

        //! Specifies minimal render area height
        renderHeightMin:     u32;

        //! Specifies maximal render area width
        renderWidthMax:      u32;

        //! Specifies maximal render area height
        renderHeightMax:     u32;

        // optimal color format
        optimalColorFormat:  DXGI_FORMAT;

        // optimal depth format
        optimalDepthFormat:  DXGI_FORMAT;
    }

    //! Returned by DirectSR plugin
    //!
    //! {38216184-79ba-48cb-93f5-7a8a59382fdf}
    DirectSRVariantInfo :: struct {
        s_structType :: StructType.{0x38216184, 0x79ba, 0x48cb, .[0x93, 0xf5, 0x7a, 0x8a, 0x59, 0x38, 0x2f, 0xdf]};
        #as using basestructure: BaseStructure = .{structType = s_structType, structVersion = kStructVersion1};
        name:                 [128] u8;
        flags:                DirectSRVariantFlags;
        optimizationRankings: [7] DirectSROptimizationType;
        optimalTargetFormat:  DXGI_FORMAT;
    }

    //! NOTE: Adding new hooks require sl.interposer to be recompiled
    //!
    //! IMPORTANT: Since SL interposer proxies supports many different versions of various D3D/DXGI interfaces
    //! we use only base interface names for our hooks.
    //!
    //! For example if API was added in IDXGISwapChain5::FUNCTION it is still named eIDXGISwapChain_FUNCTION (there is no 5 in the name)
    //!
    FunctionHookID :: enum u32 {
        eIDXGIFactory_CreateSwapChain              :: 0;
        eIDXGIFactory_CreateSwapChainForHwnd       :: 1;
        eIDXGIFactory_CreateSwapChainForCoreWindow :: 2;

        eIDXGISwapChain_Present                    :: 3;
        eIDXGISwapChain_Present1                   :: 4;
        eIDXGISwapChain_GetBuffer                  :: 5;
        eIDXGISwapChain_GetDesc                    :: 6;
        eIDXGISwapChain_ResizeBuffers              :: 7;
        eIDXGISwapChain_ResizeBuffers1             :: 8;
        eIDXGISwapChain_GetCurrentBackBufferIndex  :: 9;
        eIDXGISwapChain_SetFullscreenState         :: 10;

        eIDXGISwapChain_Destroyed                  :: 11;

        eID3D12Device_CreateCommandQueue           :: 12;

        eVulkan_Present                            :: 13;
        eVulkan_CreateSwapchainKHR                 :: 14;
        eVulkan_DestroySwapchainKHR                :: 15;
        eVulkan_GetSwapchainImagesKHR              :: 16;
        eVulkan_AcquireNextImageKHR                :: 17;
        eVulkan_DeviceWaitIdle                     :: 18;
        eVulkan_CreateWin32SurfaceKHR              :: 19;
        eVulkan_DestroySurfaceKHR                  :: 20;

        eMaxNum                                    :: 21;
    }
}

ID3D11Resource :: struct {}
ID3D11Buffer :: struct {}
ID3D11Texture2D :: struct {}

SL_VKResult :: s32;

//! Streamline core API functions (check feature specific headers for additional APIs)
//!
PFun_slInit :: #type (pref: *sl.Preferences, sdkVersion: u64) -> sl.Result #c_call;
PFun_slShutdown :: #type () -> sl.Result #c_call;
PFun_slIsFeatureSupported :: #type (feature: sl.Feature, adapterInfo: *sl.AdapterInfo) -> sl.Result #c_call;
PFun_slIsFeatureLoaded :: #type (feature: sl.Feature, loaded: *bool) -> sl.Result #c_call;
PFun_slSetFeatureLoaded :: #type (feature: sl.Feature, loaded: bool) -> sl.Result #c_call;
PFun_slEvaluateFeature :: #type (feature: sl.Feature, frame: *sl.FrameToken, inputs: **sl.BaseStructure, numInputs: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #c_call;
PFun_slAllocateResources :: #type (cmdBuffer: *sl.CommandBuffer, feature: sl.Feature, viewport: *sl.ViewportHandle) -> sl.Result #c_call;
PFun_slFreeResources :: #type (feature: sl.Feature, viewport: *sl.ViewportHandle) -> sl.Result #c_call;
PFun_slSetTag :: #type (viewport: *sl.ViewportHandle, tags: *sl.ResourceTag, numTags: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #c_call;

PFun_slSetTagForFrame :: #type (frame: *sl.FrameToken, viewport: *sl.ViewportHandle, tags: *sl.ResourceTag, numTags: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #c_call;
PFun_slGetFeatureRequirements :: #type (feature: sl.Feature, requirements: *sl.FeatureRequirements) -> sl.Result #c_call;
PFun_slGetFeatureVersion :: #type (feature: sl.Feature, version: *sl.FeatureVersion) -> sl.Result #c_call;
PFun_slUpgradeInterface :: #type (baseInterface: **void) -> sl.Result #c_call;
PFun_slSetConstants :: #type (values: *sl.Constants, frame: *sl.FrameToken, viewport: *sl.ViewportHandle) -> sl.Result #c_call;
PFun_slGetNativeInterface :: #type (proxyInterface: *void, baseInterface: **void) -> sl.Result #c_call;
PFun_slGetFeatureFunction :: #type (feature: sl.Feature, functionName: *u8, function: **void) -> sl.Result #c_call;
PFun_slGetNewFrameToken :: #type (token: **sl.FrameToken, frameIndex: *u32) -> sl.Result #c_call;
PFun_slSetD3DDevice :: #type (d3dDevice: *void) -> sl.Result #c_call;

//! Initializes the SL module
//!
//! Call this method when the game is initializing.
//!
//! @param pref Specifies preferred behavior for the SL library (SL will keep a copy)
//! @param sdkVersion Current SDK version
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
slInit :: (pref: *sl.Preferences, sdkVersion: u64 = sl.kSDKVersion) -> sl.Result #foreign sl_interposer;
slInit :: (pref: sl.Preferences, sdkVersion: u64 = sl.kSDKVersion) -> sl.Result #no_context {
    return slInit(*pref, sdkVersion);
}

//! Shuts down the SL module
//!
//! Call this method when the game is shutting down.
//!
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
slShutdown :: () -> sl.Result #foreign sl_interposer;

//! Checks if a specific feature is supported or not.
//!
//! Call this method to check if a certain e* (see above) is available.
//!
//! @param feature Specifies which feature to use
//! @param adapterInfo Adapter to check (optional)
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! NOTE: If adapter info is null SL will return general feature compatibility with the OS,
//! installed drivers or any other requirements not directly related to the adapter.
//!
//! This method is NOT thread safe.
slIsFeatureSupported :: (feature: sl.Feature, adapterInfo: *sl.AdapterInfo) -> sl.Result #foreign sl_interposer;
slIsFeatureSupported :: (feature: sl.Feature, adapterInfo: sl.AdapterInfo) -> sl.Result #no_context {
    return slIsFeatureSupported(feature, *adapterInfo);
}

//! Checks if specified feature is loaded or not.
//!
//! Call this method to check if feature is loaded.
//! All requested features are loaded by default and have to be unloaded explicitly if needed.
//!
//! @param feature Specifies which feature to check
//! @param loaded Value specifying if feature is loaded or unloaded.
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe and requires DX/VK device to be created before calling it.
slIsFeatureLoaded :: (feature: sl.Feature, loaded: *bool) -> sl.Result #foreign sl_interposer;

//! Sets the specified feature to either loaded or unloaded state.
//!
//! Call this method to load or unload certain e*.
//!
//! NOTE: All requested features are loaded by default and have to be unloaded explicitly if needed.
//!
//! @param feature Specifies which feature to check
//! @param loaded Value specifying if feature should be loaded or unloaded.
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! NOTE: When this method is called no other DXGI/D3D/Vulkan APIs should be invoked in parallel so
//! make sure to flush your pipeline before calling this method.
//!
//! This method is NOT thread safe and requires DX/VK device to be created before calling it.
slSetFeatureLoaded :: (feature: sl.Feature, loaded: bool) -> sl.Result #foreign sl_interposer;

//! NOTE: sl::PreferenceFlags::eUseFrameBasedResourceTagging must be set when using this API.
//! Tags resource globally
//!
//! Call this method to tag the appropriate buffers in global scope.
//!
//! @param frame Specifies the frame this tag applies to. Frame token can be obtained using slGetNewFrameToken API.
//! @param viewport Specifies viewport this tag applies to
//! @param tags Pointer to resources tags, set to null to remove the specified tag
//! @param numTags Number of resource tags in the provided list
//! @param cmdBuffer Command buffer to use (optional and can be null if ALL tags are null or have eValidUntilPresent life-cycle)
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! IMPORTANT: GPU payload that generates content for the provided tag(s) MUST be either already submitted to the provided command buffer
//! or some other command buffer which is guaranteed, by the host application, to be executed BEFORE the provided command buffer.
//!
//! This method is thread safe and requires DX/VK device to be created before calling it.
slSetTagForFrame :: (frame: *sl.FrameToken, viewport: *sl.ViewportHandle, resources: *sl.ResourceTag, numResources: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #foreign sl_interposer;
slSetTagForFrame :: (frame: sl.FrameToken, viewport: sl.ViewportHandle, resources: *sl.ResourceTag, numResources: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #no_context {
    return slSetTagForFrame(*frame, *viewport, resources, numResources, cmdBuffer);
}

slSetTag :: (viewport: *sl.ViewportHandle, tags: *sl.ResourceTag, numTags: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #foreign sl_interposer;
slSetTag :: (viewport: sl.ViewportHandle, tags: *sl.ResourceTag, numTags: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #no_context {
    return slSetTag(*viewport, tags, numTags, cmdBuffer);
}

//! Sets common constants.
//!
//! Call this method to provide the required data (SL will keep a copy).
//!
//! @param values Common constants required by SL plugins (SL will keep a copy)
//! @param frame Index of the current frame
//! @param viewport Unique id (can be viewport id | instance id etc.)
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is thread safe and requires DX/VK device to be created before calling it.
slSetConstants :: (values: *sl.Constants, frame: *sl.FrameToken, viewport: *sl.ViewportHandle) -> sl.Result #foreign sl_interposer;
slSetConstants :: (values: sl.Constants, frame: sl.FrameToken, viewport: sl.ViewportHandle) -> sl.Result #no_context {
    return slSetConstants(*values, *frame, *viewport);
}

//! Returns feature's requirements
//!
//! Call this method to check what is required to run certain eFeature* (see above).
//! This method must be called after init otherwise it will always return an error.
//!
//! @param feature Specifies which feature to check
//! @param requirements Data structure with feature's requirements
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
slGetFeatureRequirements :: (feature: sl.Feature, requirements: *sl.FeatureRequirements) -> sl.Result #foreign sl_interposer;

//! Returns feature's version
//!
//! Call this method to check version for a certain eFeature* (see above).
//! This method must be called after init otherwise it will always return an error.
//!
//! @param feature Specifies which feature to check
//! @param version Data structure with feature's version
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is thread safe.
slGetFeatureVersion :: (feature: sl.Feature, version: *sl.FeatureVersion) -> sl.Result #foreign sl_interposer;

//! Allocates resources for the specified feature.
//!
//! Call this method to explicitly allocate resources
//! for an instance of the specified feature.
//!
//! @param cmdBuffer Command buffer to use (must be created on device where feature is supported but can be null if not needed)
//! @param feature Feature we are working with
//! @param viewport Unique id (viewport handle)
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe and requires DX/VK device to be created before calling it.
slAllocateResources :: (cmdBuffer: *sl.CommandBuffer, feature: sl.Feature, viewport: *sl.ViewportHandle) -> sl.Result #foreign sl_interposer;
slAllocateResources :: (cmdBuffer: *sl.CommandBuffer, feature: sl.Feature, viewport: sl.ViewportHandle) -> sl.Result #no_context {
    return slAllocateResources(cmdBuffer, feature, *viewport);
}

//! Frees resources for the specified feature.
//!
//! Call this method to explicitly free resources
//! for an instance of the specified feature.
//!
//! @param feature Feature we are working with
//! @param viewport Unique id (viewport handle)
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! IMPORTANT: If slEvaluateFeature is pending on a command list, that command list must be flushed
//! before calling this method to prevent invalid resource access on the GPU.
//!
//! IMPORTANT: If slEvaluateFeature is pending on a command list, that command list must be flushed
//! before calling this method to prevent invalid resource access on the GPU.
//!
//! This method is NOT thread safe and requires DX/VK device to be created before calling it.
slFreeResources :: (feature: sl.Feature, viewport: *sl.ViewportHandle) -> sl.Result #foreign sl_interposer;
slFreeResources :: (feature: sl.Feature, viewport: sl.ViewportHandle) -> sl.Result #no_context {
    return slFreeResources(feature, *viewport);
}

//! NOTE: sl::PreferenceFlags::eUseFrameBasedResourceTagging must be set when using this API to do
//! frame-based resource tagging for multiple frames in flight at the same time.
//! Evaluates feature
//!
//! Use this method to mark the section in your rendering pipeline
//! where specific feature should be injected.
//!
//! @param feature Feature we are working with
//! @param frame Current frame handle obtained from SL
//! @param inputs The chained structures providing the input data (viewport, tags, constants etc)
//! @param numInputs Number of inputs
//! @param cmdBuffer Command buffer to use (must be created on device where feature is supported)
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! IMPORTANT: Frame and viewport must match whatever is used to set common and or feature options and constants (if any)
//!
//! NOTE: It is allowed to pass in buffer tags as inputs, they are considered to be a "local" tags and do NOT interact with
//! same tags sent in the global scope using slSetTag API.
//!
//! This method is NOT thread safe and requires DX/VK device to be created before calling it.
slEvaluateFeature :: (feature: sl.Feature, frame: *sl.FrameToken, inputs: **sl.BaseStructure, numInputs: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #foreign sl_interposer;
slEvaluateFeature :: (feature: sl.Feature, frame: sl.FrameToken, inputs: **sl.BaseStructure, numInputs: u32, cmdBuffer: *sl.CommandBuffer) -> sl.Result #no_context {
    return slEvaluateFeature(feature, *frame, inputs, numInputs, cmdBuffer);
}

//! Upgrade interface
//!
//! Use this method to upgrade basic D3D or DXGI interface to an SL proxy.
//!
//! @param baseInterface Pointer to a pointer to the base interface (for example ID3D12Device etc.) to be replaced in place.
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! IMPORTANT: This method should ONLY be used to support 3rd party SDKs like AMD AGS
//! which bypass SL or when using manual hooking.
//!
//! This method is NOT thread safe and should be called IMMEDIATELY after base interface is created.
slUpgradeInterface :: (baseInterface: **void) -> sl.Result #foreign sl_interposer;

//! Obtain native interface
//!
//! Use this method to obtain underlying D3D or DXGI interface from an SL proxy.
//!
//! IMPORTANT: When calling NVAPI or other 3rd party SDKs from your application
//! it is recommended to provide native interfaces instead of SL proxies.
//!
//! @param proxyInterface Pointer to the SL proxy (D3D device, swap-chain etc)
//! @param baseInterface Pointer to a pointer to the base interface be returned.
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe
slGetNativeInterface :: (proxyInterface: *void, baseInterface: **void) -> sl.Result #foreign sl_interposer;

//! Gets specific feature's function
//!
//! Call this method to obtain various functions for the specified feature. See sl_$feature.h for details.
//!
//! @param feature Feature we are working with
//! @param functionName The name of the API to obtain (declared in sl_[$feature].h
//! @param function Pointer to the function to return
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! IMPORTANT: Must be called AFTER device is set by calling either slSetD3DDevice or slSetVulkanInfo.
//!
//! This method is thread safe.
slGetFeatureFunction :: (feature: sl.Feature, functionName: *u8, function: **void) -> sl.Result #foreign sl_interposer;

//! Gets unique frame token
//!
//! Call this method to obtain token for the unique frame identification.
//!
//! @param handle Frame token to return
//! @param frameIndex Frame index (optional, if not provided SL internal frame counting is used)
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! NOTE: Normally SL would not expect more that 3 frames in flight due to added latency.
//!
//! This method is thread safe.
slGetNewFrameToken :: (token: **sl.FrameToken, frameIndex: *u32 = null) -> sl.Result #foreign sl_interposer;

//! Set D3D device to use
//!
//! Use this method to specify which D3D device should be used.
//!
//! @param d3dDevice D3D device to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe and should be called IMMEDIATELY after main device is created.
slSetD3DDevice :: (d3dDevice: *void) -> sl.Result #foreign sl_interposer;

//! Provides PCL settings
//!
//! Call this method to get stats etc.
//!
//! @param state Reference to a structure where states are returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slPCLGetState :: #type (state: *sl.PCLState) -> sl.Result #c_call;

//! Sets PCL marker
//!
//! Call this method to set specific PCL marker
//!
//! @param marker Specifies which marker to use
//! @param frame Specifies current frame
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is thread safe.
PFun_slPCLSetMarker :: #type (marker: sl.PCLMarker, frame: *sl.FrameToken) -> sl.Result #c_call;

//! Sets PCL options
//!
//! Call this method to set PCL options.
//!
//! @param options Specifies options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slPCLSetOptions :: #type (options: *sl.PCLOptions) -> sl.Result #c_call;

//! Provides Reflex settings
//!
//! Call this method to check if Reflex is on, get stats etc.
//!
//! @param state Reference to a structure where states are returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slReflexGetState :: #type (state: *sl.ReflexState) -> sl.Result #c_call;

//! Tells reflex to sleep the app
//!
//! Call this method to invoke Reflex sleep in your application.
//!
//! @param frame Specifies current frame
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is thread safe.
PFun_slReflexSleep :: #type (frame: *sl.FrameToken) -> sl.Result #c_call;

//! Sets Reflex options
//!
//! Call this method to turn Reflex on/off, change mode etc.
//!
//! @param options Specifies options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slReflexSetOptions :: #type (options: *sl.ReflexOptions) -> sl.Result #c_call;

//! Sets Reflex camera data
//!
//! Call this method to inform Reflex of upcoming camera data
//!
//! @param viewport The viewport the camera corresponds to
//! @param frame The frame to set camera data for
//! @param inCameraData Camera data for an upcoming render frame
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is thread safe.
PFun_slReflexSetCameraData :: #type (viewport: *sl.ViewportHandle, frame: *sl.FrameToken, inCameraData: *sl.ReflexCameraData) -> sl.Result #c_call;

//! Gets predicted Reflex camera data
//!
//! Call this method to get a prediction of upcoming camera data
//!
//! @param viewport The viewport the camera corresponds to
//! @param frame The frame to get camera data for (if available)
//! @param outCameraData Predicted Camera data for an upcoming render frame
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is thread safe.
PFun_slReflexGetPredictedCameraData :: #type (viewport: *sl.ViewportHandle, frame: *sl.FrameToken, outCameraData: *sl.ReflexPredictedCameraData) -> sl.Result #c_call;

//! Provides optimal DLSS settings
//!
//! Call this method to obtain optimal render target size and other DLSS related settings.
//!
//! @param options Specifies DLSS options to use
//! @param settings Reference to a structure where settings are returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDLSSGetOptimalSettings :: #type (options: *sl.DLSSOptions, settings: *sl.DLSSOptimalSettings) -> sl.Result #c_call;

//! Provides DLSS state for the given viewport
//!
//! Call this method to obtain optimal render target size and other DLSS related settings.
//!
//! @param viewport Specified viewport we are working with
//! @param state Reference to a structure where state is to be returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDLSSGetState :: #type (viewport: *sl.ViewportHandle, state: *sl.DLSSState) -> sl.Result #c_call;

//! Sets DLSS options
//!
//! Call this method to turn DLSS on/off, change mode etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies DLSS options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDLSSSetOptions :: #type (viewport: *sl.ViewportHandle, options: *sl.DLSSOptions) -> sl.Result #c_call;

//! Sets NIS options
//!
//! Call this method to turn DLSS on/off, change mode etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies NIS options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slNISSetOptions :: #type (viewport: *sl.ViewportHandle, options: *sl.NISOptions) -> sl.Result #c_call;

//! Provides NIS state for the given viewport
//!
//! Call this method to obtain VRAM usage and other information.
//!
//! @param viewport Specified viewport we are working with
//! @param state Reference to a structure where state is to be returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slNISGetState :: #type (viewport: *sl.ViewportHandle, state: *sl.NISState) -> sl.Result #c_call;

//! Provides optimal DLSSD settings
//!
//! Call this method to obtain optimal render target size and other DLSSD related settings.
//!
//! @param options Specifies DLSSD options to use
//! @param settings Reference to a structure where settings are returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDLSSDGetOptimalSettings :: #type (options: *sl.DLSSDOptions, settings: *sl.DLSSDOptimalSettings) -> sl.Result #c_call;

//! Provides DLSSD state for the given viewport
//!
//! Call this method to obtain optimal render target size and other DLSSD related settings.
//!
//! @param viewport Specified viewport we are working with
//! @param state Reference to a structure where state is to be returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDLSSDGetState :: #type (viewport: *sl.ViewportHandle, state: *sl.DLSSDState) -> sl.Result #c_call;

//! Sets DLSSD options
//!
//! Call this method to turn DLSSD on/off, change mode etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies DLSSD options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDLSSDSetOptions :: #type (viewport: *sl.ViewportHandle, options: *sl.DLSSDOptions) -> sl.Result #c_call;

//! Provides DLSS-G state
//!
//! Call this method to obtain current state of DLSS-G
//!
//! @param viewport Specified viewport we are working with
//! @param state Reference to a structure where state is returned
//! @param options Specifies DLSS-G options to use (can be null if not needed)
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDLSSGGetState :: #type (viewport: *sl.ViewportHandle, state: *sl.DLSSGState, options: *sl.DLSSGOptions) -> sl.Result #c_call;

//! Sets DLSS-G options
//!
//! Call this method to turn DLSS-G on/off, change modes etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies DLSS-G options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDLSSGSetOptions :: #type (viewport: *sl.ViewportHandle, options: *sl.DLSSGOptions) -> sl.Result #c_call;

//! Sets DeepDVC options
//!
//! Call this method to turn DeepDVC on/off, change mode etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies DeepDVC options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDeepDVCSetOptions :: #type (viewport: *sl.ViewportHandle, options: *sl.DeepDVCOptions) -> sl.Result #c_call;

//! Provides DeepDVC state for the given viewport
//!
//! Call this method to obtain VRAM usage and other information.
//!
//! @param viewport Specified viewport we are working with
//! @param state Reference to a structure where state is to be returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDeepDVCGetState :: #type (viewport: *sl.ViewportHandle, state: *sl.DeepDVCState) -> sl.Result #c_call;

//! Provides optimal DirectSR settings
//!
//! Call this method to obtain optimal render target size and other DirectSR related settings.
//!
//! @param options Specifies DirectSR options to use
//! @param settings Reference to a structure where settings are returned
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDirectSRGetOptimalSettings :: #type (options: *sl.DirectSROptions, settings: *sl.DirectSROptimalSettings) -> sl.Result #c_call;

//! Retrive information about the available DirectSR variants.
PFun_slDirectSRGetVariantInfo :: #type (numVariants: *u32, variantInfo: *sl.DirectSRVariantInfo) -> sl.Result #c_call;

//! Sets DirectSR options
//!
//! Call this method to turn DirectSR on/off, change mode etc.
//!
//! @param viewport Specified viewport we are working with
//! @param options Specifies DirectSR options to use
//! @return sl::ResultCode::eOk if successful, error code otherwise (see sl_result.h for details)
//!
//! This method is NOT thread safe.
PFun_slDirectSRSetOptions :: #type (viewport: *sl.ViewportHandle, options: *sl.DirectSROptions) -> sl.Result #c_call;

VkPhysicalDevice_T :: struct {}
VkDevice_T :: struct {}
VkInstance_T :: struct {}

VkPhysicalDevice :: *VkPhysicalDevice_T;
VkDevice :: *VkDevice_T;
VkInstance :: *VkInstance_T;

slDeepDVCSetOptions :: (viewport: *sl.ViewportHandle, options: *sl.DeepDVCOptions) -> sl.Result {
    if !s_slDeepDVCSetOptions {
        res := slGetFeatureFunction(sl.kFeatureDeepDVC, "slDeepDVCSetOptions", xx *s_slDeepDVCSetOptions);
        if res != .eOk  return res;
    }
    return s_slDeepDVCSetOptions(viewport, options);
}

slDeepDVCGetState :: (viewport: *sl.ViewportHandle, state: *sl.DeepDVCState) -> sl.Result {
    if !s_slDeepDVCGetState {
        res := slGetFeatureFunction(sl.kFeatureDeepDVC, "slDeepDVCGetState", xx *s_slDeepDVCGetState);
        if res != .eOk  return res;
    }
    return s_slDeepDVCGetState(viewport, state);
}

slDirectSRGetOptimalSettings :: (options: *sl.DirectSROptions, settings: *sl.DirectSROptimalSettings) -> sl.Result {
    if !s_slDirectSRGetOptimalSettings {
        res := slGetFeatureFunction(sl.kFeatureDirectSR, "slDirectSRGetOptimalSettings", xx *s_slDirectSRGetOptimalSettings);
        if res != .eOk  return res;
    }
    return s_slDirectSRGetOptimalSettings(options, settings);
}

slDirectSRGetVariantInfo :: (numVariants: *u32, variantInfo: *sl.DirectSRVariantInfo) -> sl.Result {
    if !s_slDirectSRGetVariantInfo {
        res := slGetFeatureFunction(sl.kFeatureDirectSR, "slDirectSRGetVariantInfo", xx *s_slDirectSRGetVariantInfo);
        if res != .eOk  return res;
    }
    return s_slDirectSRGetVariantInfo(numVariants, variantInfo);
}

slDirectSRSetOptions :: (viewport: *sl.ViewportHandle, options: *sl.DirectSROptions) -> sl.Result {
    if !s_slDirectSRSetOptions {
        res := slGetFeatureFunction(sl.kFeatureDirectSR, "slDirectSRSetOptions", xx *s_slDirectSRSetOptions);
        if res != .eOk  return res;
    }
    return s_slDirectSRSetOptions(viewport, options);
}

slDLSSGetOptimalSettings :: (options: *sl.DLSSOptions, settings: *sl.DLSSOptimalSettings) -> sl.Result {
    if !s_slDLSSGetOptimalSettings {
        res := slGetFeatureFunction(sl.kFeatureDLSS, "slDLSSGetOptimalSettings", xx *s_slDLSSGetOptimalSettings);
        if res != .eOk  return res;
    }
    return s_slDLSSGetOptimalSettings(options, settings);
}

slDLSSGetState :: (viewport: *sl.ViewportHandle, state: *sl.DLSSState) -> sl.Result {
    if !s_slDLSSGetState {
        res := slGetFeatureFunction(sl.kFeatureDLSS, "slDLSSGetState", xx *s_slDLSSGetState);
        if res != .eOk  return res;
    }
    return s_slDLSSGetState(viewport, state);
}

slDLSSSetOptions :: (viewport: *sl.ViewportHandle, options: *sl.DLSSOptions) -> sl.Result {
    if !s_slDLSSSetOptions {
        res := slGetFeatureFunction(sl.kFeatureDLSS, "slDLSSSetOptions", xx *s_slDLSSSetOptions);
        if res != .eOk  return res;
    }
    return s_slDLSSSetOptions(viewport, options);
}

slDLSSDGetOptimalSettings :: (options: *sl.DLSSDOptions, settings: *sl.DLSSDOptimalSettings) -> sl.Result {
    if !s_slDLSSDGetOptimalSettings {
        res := slGetFeatureFunction(sl.kFeatureDLSS_RR, "slDLSSDGetOptimalSettings", xx *s_slDLSSDGetOptimalSettings);
        if res != .eOk  return res;
    }
    return s_slDLSSDGetOptimalSettings(options, settings);
}

slDLSSDGetState :: (viewport: *sl.ViewportHandle, state: *sl.DLSSDState) -> sl.Result {
    if !s_slDLSSDGetState {
        res := slGetFeatureFunction(sl.kFeatureDLSS_RR, "slDLSSDGetState", xx *s_slDLSSDGetState);
        if res != .eOk  return res;
    }
    return s_slDLSSDGetState(viewport, state);
}

slDLSSDSetOptions :: (viewport: *sl.ViewportHandle, options: *sl.DLSSDOptions) -> sl.Result {
    if !s_slDLSSDSetOptions {
        res := slGetFeatureFunction(sl.kFeatureDLSS_RR, "slDLSSDSetOptions", xx *s_slDLSSDSetOptions);
        if res != .eOk  return res;
    }
    return s_slDLSSDSetOptions(viewport, options);
}

slDLSSGGetState :: (viewport: *sl.ViewportHandle, state: *sl.DLSSGState, options: *sl.DLSSGOptions) -> sl.Result {
    if !s_slDLSSGGetState {
        res := slGetFeatureFunction(sl.kFeatureDLSS_G, "slDLSSGGetState", xx *s_slDLSSGGetState);
        if res != .eOk  return res;
    }
    return s_slDLSSGGetState(viewport, state, options);
}

slDLSSGSetOptions :: (viewport: *sl.ViewportHandle, options: *sl.DLSSGOptions) -> sl.Result {
    if !s_slDLSSGSetOptions {
        res := slGetFeatureFunction(sl.kFeatureDLSS_G, "slDLSSGSetOptions", xx *s_slDLSSGSetOptions);
        if res != .eOk  return res;
    }
    return s_slDLSSGSetOptions(viewport, options);
}

slNISSetOptions :: (viewport: *sl.ViewportHandle, options: *sl.NISOptions) -> sl.Result {
    if !s_slNISSetOptions {
        res := slGetFeatureFunction(sl.kFeatureNIS, "slNISSetOptions", xx *s_slNISSetOptions);
        if res != .eOk  return res;
    }
    return s_slNISSetOptions(viewport, options);
}

slNISGetState :: (viewport: *sl.ViewportHandle, state: *sl.NISState) -> sl.Result {
    if !s_slNISGetState {
        res := slGetFeatureFunction(sl.kFeatureNIS, "slNISGetState", xx *s_slNISGetState);
        if res != .eOk  return res;
    }
    return s_slNISGetState(viewport, state);
}

slPCLGetState :: (state: *sl.PCLState) -> sl.Result {
    if !s_slPCLGetState {
        res := slGetFeatureFunction(sl.kFeaturePCL, "slPCLGetState", xx *s_slPCLGetState);
        if res != .eOk  return res;
    }
    return s_slPCLGetState(state);
}

slPCLSetMarker :: (marker: sl.PCLMarker, frame: *sl.FrameToken) -> sl.Result {
    if !s_slPCLSetMarker {
        res := slGetFeatureFunction(sl.kFeaturePCL, "slPCLSetMarker", xx *s_slPCLSetMarker);
        if res != .eOk  return res;
    }
    return s_slPCLSetMarker(marker, frame);
}

slPCLSetOptions :: (options: *sl.PCLOptions) -> sl.Result {
    if !s_slPCLSetOptions {
        res := slGetFeatureFunction(sl.kFeaturePCL, "slPCLSetOptions", xx *s_slPCLSetOptions);
        if res != .eOk  return res;
    }
    return s_slPCLSetOptions(options);
}

slReflexGetState :: (state: *sl.ReflexState) -> sl.Result {
    if !s_slReflexGetState {
        res := slGetFeatureFunction(sl.kFeatureReflex, "slReflexGetState", xx *s_slReflexGetState);
        if res != .eOk  return res;
    }
    return s_slReflexGetState(state);
}

slReflexSleep :: (frame: *sl.FrameToken) -> sl.Result {
    if !s_slReflexSleep {
        res := slGetFeatureFunction(sl.kFeatureReflex, "slReflexSleep", xx *s_slReflexSleep);
        if res != .eOk  return res;
    }
    return s_slReflexSleep(frame);
}

slReflexSetOptions :: (options: *sl.ReflexOptions) -> sl.Result {
    if !s_slReflexSetOptions {
        res := slGetFeatureFunction(sl.kFeatureReflex, "slReflexSetOptions", xx *s_slReflexSetOptions);
        if res != .eOk  return res;
    }
    return s_slReflexSetOptions(options);
}

slReflexSetCameraData :: (viewport: *sl.ViewportHandle, frame: *sl.FrameToken, inCameraData: *sl.ReflexCameraData) -> sl.Result {
    if !s_slReflexSetCameraData {
        res := slGetFeatureFunction(sl.kFeatureReflex, "slReflexSetCameraData", xx *s_slReflexSetCameraData);
        if res != .eOk  return res;
    }
    return s_slReflexSetCameraData(viewport, frame, inCameraData);
}

slReflexGetPredictedCameraData :: (viewport: *sl.ViewportHandle, frame: *sl.FrameToken, outCameraData: *sl.ReflexPredictedCameraData) -> sl.Result {
    if !s_slReflexGetPredictedCameraData {
        res := slGetFeatureFunction(sl.kFeatureReflex, "slReflexGetPredictedCameraData", xx *s_slReflexGetPredictedCameraData);
        if res != .eOk  return res;
    }
    return s_slReflexGetPredictedCameraData(viewport, frame, outCameraData);
}

#scope_file

s_slDeepDVCSetOptions: PFun_slDeepDVCSetOptions;
s_slDeepDVCGetState: PFun_slDeepDVCGetState;
s_slDirectSRGetOptimalSettings: PFun_slDirectSRGetOptimalSettings;
s_slDirectSRGetVariantInfo: PFun_slDirectSRGetVariantInfo;
s_slDirectSRSetOptions: PFun_slDirectSRSetOptions;
s_slDLSSGetOptimalSettings: PFun_slDLSSGetOptimalSettings;
s_slDLSSGetState: PFun_slDLSSGetState;
s_slDLSSSetOptions: PFun_slDLSSSetOptions;
s_slDLSSDGetOptimalSettings: PFun_slDLSSDGetOptimalSettings;
s_slDLSSDGetState: PFun_slDLSSDGetState;
s_slDLSSDSetOptions: PFun_slDLSSDSetOptions;
s_slDLSSGGetState: PFun_slDLSSGGetState;
s_slDLSSGSetOptions: PFun_slDLSSGSetOptions;
s_slNISSetOptions: PFun_slNISSetOptions;
s_slNISGetState: PFun_slNISGetState;
s_slPCLGetState: PFun_slPCLGetState;
s_slPCLSetMarker: PFun_slPCLSetMarker;
s_slPCLSetOptions: PFun_slPCLSetOptions;
s_slReflexGetState: PFun_slReflexGetState;
s_slReflexSleep: PFun_slReflexSleep;
s_slReflexSetOptions: PFun_slReflexSetOptions;
s_slReflexSetCameraData: PFun_slReflexSetCameraData;
s_slReflexGetPredictedCameraData: PFun_slReflexGetPredictedCameraData;

sl_interposer :: #library "bin/sl.interposer";
