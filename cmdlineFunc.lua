
-- 供C程序使用的lua对象
M = {}
local file_path = "env.dat" -- 存放最终结果

-- 显示用户操作主界面
function M.showUserOptUI()
    print([==[*******************************************
*            欢迎进入简易命令行系统       *
*                                         *
*   1. 查询环境变量                       *
*                                         *
*   2. 执行系统指令                       *
*                                         *
*******************************************]==])
    
    repeat
        print("请选择序号：")
        local iNo = io.read()
        local toNo = tonumber(iNo)
        if 1 == toNo then
            serchEnvVariable()
            break
        elseif 2 == toNo then
            exeSystemCmd()
            break
        end  
    until iNo == ""
end

-- 校验文件，失败需初始化环境
function checkIsVaildFile()
    local ifile = io.open(file_path, "r")

    if ifile then
        local all_data = ifile:read("*all")

        local s,e = string.find(all_data, "name=\"windir\"")
        if not s then
            initEnvironment()
        end
    else
        initEnvironment()
    end

end

-- 初始化环境变量信息
function initEnvironment()
    local tmp_file_path = "aa.txt" -- 临时文件
    local exe_rst = os.execute("set > "..tmp_file_path)
    if exe_rst ~= 0 then
        print("get env-var failed!")
        return
    end

    local ifile = io.open(tmp_file_path, "r")
    local val_index_tab = {}
    --setmetatable(val_index_tab, {__mode = "v"}) -- 设置‘v’弱用表

    local line = ifile:read("*line")
    while line do
        -- 搜索k-v对
        local kstr,vstr = string.match(line, "([%w%p_]+)=([%w%s_%p]+)")

        if vstr[#vstr] ~= ';' then
            vstr = string.format("%s;", vstr)
        end

        local tl = #val_index_tab
        val_index_tab[tl+1] = {}
        val_index_tab[tl+1].name = kstr
        val_index_tab[tl+1].vlist = {}

        -- 展开所有的v，并保存
        for item in string.gmatch(vstr, "([%w%s_%p]-);") do
            if item ~= "" then
                local c_l = #val_index_tab[tl+1].vlist
                val_index_tab[tl+1].vlist[c_l+1] = item
            end
        end
        
        line = ifile:read("*line") 
    end

    -- 关闭并移除文件
    ifile:close()
    os.remove(tmp_file_path)

    -- 将待写入的数据格式化成table
    fomratTable(val_index_tab, file_path) 
end

-- 格式化table到指定文件
function fomratTable(tabEnv,filePath)
    local strFormatData = "Entry{"

    for i=1,#tabEnv do
        strFormatData = string.format("%s{name=%q,vlist={", strFormatData, tabEnv[i].name)

        for j=1,#tabEnv[i].vlist do
            if j == #tabEnv[i].vlist then
                strFormatData = string.format("%s%q}},",strFormatData, tabEnv[i].vlist[j])
            else
                strFormatData = string.format("%s%q,", strFormatData, tabEnv[i].vlist[j])
            end
        end
    end

    strFormatData = string.format("%s}", strFormatData)
    local ifile = io.open(filePath, "w")
    ifile:write(strFormatData);
    ifile:close()
end

-- 模拟执行指令
function exeSystemCmd()
    repeat
        print("\n请输入系统指令（q退出，r返回主界面）：")

        local sys_cmd = io.read()
        if sys_cmd == "q" then
            os.exit()
        elseif sys_cmd == "r" then
            M.showUserOptUI()
            break
        else
            os.execute(sys_cmd)
        end
    until sys_cmd == ""

end

-- 根据数字序号或变量前n个字符模糊查询
function serchEnvVariable()
   --checkIsVaildFile()
   initEnvironment()

    --读取环境信息
    M.env_info_tab = {}
    local f = loadfile(file_path)
    Entry=entry1
    if f then f() end    

    --显示所有环境变量列表
    showEnvList()

    --查询环境变量
    repeat
        print("请输入序号或前缀查询（q退出，r返回主界面，l显示变量列表）：")
        local n_prev = io.read()
        local nv = tonumber(n_prev)

        if nv then
            --数字，直接索引
            printIndexElemInTab(nv)
        elseif n_prev == "q" then
            os.exit()
        elseif n_prev == "r" then
            M.showUserOptUI()
            break
        elseif n_prev == "l" then
            showEnvList()
        else
            --字符串，匹配前缀
            local match_info = ""
            local index_tab = {}
            for i=1,#M.env_info_tab do
                local str_name = M.env_info_tab[i].name

                --处理成不区分大小写的模式串
                local pattern_str = "^"
                for j=1,#n_prev do
                    pattern_str = string.format("%s[%s%s]", pattern_str, string.lower(string.sub(n_prev,j,j)), string.upper(string.sub(n_prev,j,j)))
                end

                local mstr = string.match(str_name, pattern_str)
                if mstr then
                    index_tab[#index_tab+1] = i
                    match_info = string.format("%s\n%d. %s", match_info, i, str_name)
                end
            end

            if #index_tab == 0 then
                print("无查询结果!\n")
            else 
                print(match_info)

                repeat
                    print("请输入有效的数字索引(r返回上一层)：")
                    local two_io = io.read()
                    local n_io = tonumber(two_io)

                    if two_io == "r" then
                        break
                    end
                    
                    --在查询列表中匹配数字
                    if n_io then
                        local b_ok = false
                        for i=1,#index_tab do
                            if n_io == index_tab[i] then
                                printIndexElemInTab(n_io)
                                b_ok = true
                                break
                            end
                        end

                        if b_ok then
                            break
                        end
                    end

                until two_io == ""
            end
        end
    until n_prev == ""
end

--显示环境变量列表
function showEnvList()
    local str_print_list = "\n系统中所有的环境变量："
    for i=1,#M.env_info_tab do
        str_print_list = string.format("%s\n%d. %s", str_print_list, i, M.env_info_tab[i].name)
    end
    print(str_print_list)
end

-- 打印对应下标的元素
function printIndexElemInTab(index)
    local str_show = string.format("%s = {\n", M.env_info_tab[index].name)
    local vlist = M.env_info_tab[index].vlist

    for i=1,#vlist do
        if i ~= #vlist then
            str_show = string.format("%s%s,\n", str_show, vlist[i])
        else
            str_show = string.format("%s%s\n}", str_show, vlist[i])
        end
    end
    print(str_show)
end

--读取文件信息，至缓存tab
function entry1(o)
    for i=1,#o do
        M.env_info_tab[i]={}
        M.env_info_tab[i].name = o[i].name
        M.env_info_tab[i].vlist = {}
            
        for j=1,#o[i].vlist do
            M.env_info_tab[i].vlist[j] = o[i].vlist[j]
        end
    end
end

