
-- 供C程序使用的lua对象
M = {}
setmetatable(M, {__index = _G})

local file_path = "env.dat"

-- 校验文件，失败需初始化环境

-- 初始化环境变量信息
function M.initEnvironment()
    local str_src_data = os.execute("set");
    local val_index_tab = {}
    setmettable(val_index_tab, {__mode = "v"}) -- 设置‘v’弱用表

    io.input()

    for kstr,vstr in string.gmatch(str_src_data, "([%w_]+)=([%w_]+)") do
        local tl = #val_index_tab
        val_index_tab[tl+1] = {}
        val_index_tab[tl+1].name = kstr
        val_index_tab[tl+1].vlist = {}

        -- 对拆分的

    end
end

-- 显示用户操作主界面

-- 模拟执行指令

-- 根据数字序号或变量前n个字符模糊查询

--return M