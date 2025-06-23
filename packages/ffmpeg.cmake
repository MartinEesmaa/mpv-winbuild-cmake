ExternalProject_Add(ffmpeg
    DEPENDS
        amf-headers
        avisynth-headers
        ${nvcodec_headers}
        bzip2
        lame
        lcms2
        openssl
        libssh
        libsrt
        libass
        libbluray
        libdvdnav
        libdvdread
        libmodplug
        libpng
        libsoxr
        libbs2b
        libvpx
        libwebp
        libzimg
        libmysofa
        fontconfig
        harfbuzz
        opus
        speex
        vorbis
        x264
        ${ffmpeg_x265}
        xvidcore
        libxml2
        libvpl
        libopenmpt
        libjxl
        shaderc
        libplacebo
        libzvbi
        libaribcaption
        aom
        svtav1
        dav1d
        vvdec
        fdk-aac
        vapoursynth
        ${ffmpeg_uavs3d}
        ${ffmpeg_davs2}
        rubberband
        libva
    GIT_REPOSITORY https://github.com/MartinEesmaa/FFmpeg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !tests/ref/fate"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND
        bash -c "
            export PATH=${CMAKE_INSTALL_PREFIX}/bin:\$PATH
            export CC=${TARGET_ARCH}-gcc
            export CXX=${TARGET_ARCH}-g++
            export AR=${TARGET_ARCH}-ar
            export LD=${TARGET_ARCH}-ld
            export NM=${TARGET_ARCH}-nm
            export STRIP=${TARGET_ARCH}-strip
            cd <BINARY_DIR>
            <SOURCE_DIR>/configure
                --cross-prefix=${CMAKE_INSTALL_PREFIX}/bin/${TARGET_ARCH}-
                --prefix=${MINGW_INSTALL_PREFIX}
                --incdir=${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}/include
                --libdir=${CMAKE_INSTALL_PREFIX}/${TARGET_ARCH}/lib
                --arch=${TARGET_CPU}
                --target-os=mingw32
                --pkg-config-flags=--static
                --enable-cross-compile
                --enable-runtime-cpudetect
                --enable-gpl
                --enable-version3
                --enable-nonfree
                --enable-avisynth
                --enable-vapoursynth
                --enable-libass
                --enable-libbluray
                --enable-libdvdnav
                --enable-libdvdread
                --enable-libfreetype
                --enable-libfribidi
                --enable-libfontconfig
                --enable-libharfbuzz
                --enable-libmodplug
                --enable-libopenmpt
                --enable-libmp3lame
                --enable-lcms2
                --enable-libopus
                --enable-libsoxr
                --enable-libspeex
                --enable-libvorbis
                --enable-libbs2b
                --enable-librubberband
                --enable-libvpx
                --enable-libwebp
                --enable-libx264
                --enable-libx265
                --enable-libaom
                --enable-libsvtav1
                --enable-libdav1d
                --enable-libvvdec
                --enable-libfdk_aac
                ${ffmpeg_davs2_cmd}
                ${ffmpeg_uavs3d_cmd}
                --enable-libxvid
                --enable-libzimg
                --enable-openssl
                --enable-libxml2
                --enable-libmysofa
                --enable-libssh
                --enable-libsrt
                --enable-libvpl
                --enable-libjxl
                --enable-libplacebo
                --enable-libshaderc
                --enable-libzvbi
                --enable-libaribcaption
                ${ffmpeg_cuda}
                --enable-amf
                --enable-openal
                --enable-opengl
                --disable-doc
                --disable-ffplay
                --disable-ffprobe
                --enable-vaapi
                --disable-vdpau
                --disable-videotoolbox
                --disable-decoder=libaom_av1
                ${ffmpeg_lto}
                --extra-cflags='-Wno-error=int-conversion'
                \"--extra-libs='${ffmpeg_extra_libs}'\"
                --extra-version=VVCEasy
        "
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
cleanup(ffmpeg install)
