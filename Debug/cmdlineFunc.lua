
-- ��C����ʹ�õ�lua����
M = {}
setmetatable(M, {__index = _G})

local file_path = "env.dat"

-- У���ļ���ʧ�����ʼ������

-- ��ʼ������������Ϣ
function M.initEnvironment()
    local str_src_data = os.execute("set");
    local val_index_tab = {}
    setmettable(val_index_tab, {__mode = "v"}) -- ���á�v�����ñ�

    io.input()

    for kstr,vstr in string.gmatch(str_src_data, "([%w_]+)=([%w_]+)") do
        local tl = #val_index_tab
        val_index_tab[tl+1] = {}
        val_index_tab[tl+1].name = kstr
        val_index_tab[tl+1].vlist = {}

        -- �Բ�ֵ�

    end
end

-- ��ʾ�û�����������

-- ģ��ִ��ָ��

-- ����������Ż����ǰn���ַ�ģ����ѯ

--return M