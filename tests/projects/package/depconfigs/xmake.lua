add_requires("libpng", "libtiff", {system = false, configs = {vs_runtime = "MD"}})
add_requires("libwebp")

add_requireconfs("libwebp",      {system = false, configs = {shared = true, vs_runtime = "MD"}})
add_requireconfs("libpng.zlib",  {system = false, configs = {cxflags = "-DTEST1"}, version = "1.2.10"})
add_requireconfs("libtiff.*",    {system = false, configs = {cxflags = "-DTEST2"}})
add_requireconfs("libwebp.**",   {system = false, configs = {cxflags = "-DTEST3"}})

target("test")
    set_kind("binary")
    add_files("src/*.c")
    add_packages("libpng")
    before_build(function (target)
        local found
        for _, linkdir in ipairs(target:pkg("libpng"):get("linkdirs")) do
            if linkdir:find("zlib/1.2.10", 1, true) then
                found = true
            end
        end
        assert(found, "package(zlib 1.2.10) not found!")
    end)

target("test2")
    set_kind("binary")
    add_files("src/*.c")
    add_packages("libtiff")
    before_build(function (target)
        local found
        for _, linkdir in ipairs(target:pkg("libtiff"):get("linkdirs")) do
            if linkdir:find("zlib", 1, true) then
                found = true
            end
        end
        assert(found, "package(zlib) not found!")
    end)

target("test3")
    set_kind("binary")
    add_files("src/*.c")
    add_packages("libwebp")
    before_build(function (target)
        local found
        for _, linkdir in ipairs(target:pkg("libwebp"):get("linkdirs")) do
            if linkdir:find("zlib", 1, true) then
                found = true
            end
        end
        assert(found, "package(zlib) not found!")
    end)
