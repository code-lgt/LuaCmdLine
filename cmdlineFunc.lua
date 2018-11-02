
-- ��C����ʹ�õ�lua����
M = {}
local file_path = "env.dat" -- ������ս��

-- ��ʾ�û�����������
function M.showUserOptUI()
    print([==[*******************************************
*            ��ӭ�������������ϵͳ       *
*                                         *
*   1. ��ѯ��������                       *
*                                         *
*   2. ִ��ϵͳָ��                       *
*                                         *
*******************************************]==])
    
    repeat
        print("��ѡ����ţ�")
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

-- У���ļ���ʧ�����ʼ������
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

-- ��ʼ������������Ϣ
function initEnvironment()
    local tmp_file_path = "aa.txt" -- ��ʱ�ļ�
    local exe_rst = os.execute("set > "..tmp_file_path)
    if exe_rst ~= 0 then
        print("get env-var failed!")
        return
    end

    local ifile = io.open(tmp_file_path, "r")
    local val_index_tab = {}
    --setmetatable(val_index_tab, {__mode = "v"}) -- ���á�v�����ñ�

    local line = ifile:read("*line")
    while line do
        -- ����k-v��
        local kstr,vstr = string.match(line, "([%w%p_]+)=([%w%s_%p]+)")

        if vstr[#vstr] ~= ';' then
            vstr = string.format("%s;", vstr)
        end

        local tl = #val_index_tab
        val_index_tab[tl+1] = {}
        val_index_tab[tl+1].name = kstr
        val_index_tab[tl+1].vlist = {}

        -- չ�����е�v��������
        for item in string.gmatch(vstr, "([%w%s_%p]-);") do
            if item ~= "" then
                local c_l = #val_index_tab[tl+1].vlist
                val_index_tab[tl+1].vlist[c_l+1] = item
            end
        end
        
        line = ifile:read("*line") 
    end

    -- �رղ��Ƴ��ļ�
    ifile:close()
    os.remove(tmp_file_path)

    -- ����д������ݸ�ʽ����table
    fomratTable(val_index_tab, file_path) 
end

-- ��ʽ��table��ָ���ļ�
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

-- ģ��ִ��ָ��
function exeSystemCmd()
    repeat
        print("\n������ϵͳָ�q�˳���r���������棩��")

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

-- ����������Ż����ǰn���ַ�ģ����ѯ
function serchEnvVariable()
   --checkIsVaildFile()
   initEnvironment()

    --��ȡ������Ϣ
    M.env_info_tab = {}
    local f = loadfile(file_path)
    Entry=entry1
    if f then f() end    

    --��ʾ���л��������б�
    showEnvList()

    --��ѯ��������
    repeat
        print("��������Ż�ǰ׺��ѯ��q�˳���r���������棬l��ʾ�����б���")
        local n_prev = io.read()
        local nv = tonumber(n_prev)

        if nv then
            --���֣�ֱ������
            printIndexElemInTab(nv)
        elseif n_prev == "q" then
            os.exit()
        elseif n_prev == "r" then
            M.showUserOptUI()
            break
        elseif n_prev == "l" then
            showEnvList()
        else
            --�ַ�����ƥ��ǰ׺
            local match_info = ""
            local index_tab = {}
            for i=1,#M.env_info_tab do
                local str_name = M.env_info_tab[i].name

                --����ɲ����ִ�Сд��ģʽ��
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
                print("�޲�ѯ���!\n")
            else 
                print(match_info)

                repeat
                    print("��������Ч����������(r������һ��)��")
                    local two_io = io.read()
                    local n_io = tonumber(two_io)

                    if two_io == "r" then
                        break
                    end
                    
                    --�ڲ�ѯ�б���ƥ������
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

--��ʾ���������б�
function showEnvList()
    local str_print_list = "\nϵͳ�����еĻ���������"
    for i=1,#M.env_info_tab do
        str_print_list = string.format("%s\n%d. %s", str_print_list, i, M.env_info_tab[i].name)
    end
    print(str_print_list)
end

-- ��ӡ��Ӧ�±��Ԫ��
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

--��ȡ�ļ���Ϣ��������tab
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

