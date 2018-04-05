-- 链接地址形如: /2016-04-29/key-MjAxNi0wNS0xNjpqZmpkc2phZms=/cmSJ46Vl1j9i2Noln8c8_ND.mp4
-- MjAxNi0wNS0xNjpqZmpkc2phZms= 解密后形如2016-05-16-20-19:jfjdsjafk, :前半部分为过期时间, 精确到分, 后半部分为设置的密钥
-- 密钥应该已经在配置文件中进行了设置, 密钥变量为ngx.var.validKey

local token='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
function encode(data)
    return ((data:gsub('.', function(x) 
        local r,token='',x:byte()
        for i=8,1,-1 do r=r..(token%2^i-token%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return token:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function decode(data)
    data = string.gsub(data, '[^'..token..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(token:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local is_vip_rmpt = false;
local validKey = ngx.var.validKey;
local uri = ngx.var.uri;
local encodeKey = string.sub(uri,6);


local decodeKey = decode(encodeKey);

local expireDate, firstDir, fileName, isVip, tokenStr = string.match(decodeKey, "(.+):(.+):(.+):(.+):(.+)");
if validKey == tokenStr then
	local year, month, day, hour, min = string.match(expireDate, "(%d+)%-(%d+)%-(%d+)%-(%d+)%-(%d+)");

	local nowTime = math.floor(ngx.now());
	local validTime = os.time({year=year, month=month, day=day, hour=hour, min=min});
	if validTime > nowTime then
        if is_vip_rmpt and ngx.var.remote_addr ~= isVip then
                ngx.exit(404);
        end
		local rewriteUri = '/' .. firstDir .. '/' .. fileName;
		-- true: => 终止执行当前location之后的逻辑, 执行新的rewrite后的location的逻辑
		-- false: => 继续执行当前location之后的逻辑, 只不过uri已经被改变
        -- ngx.log(ngx.ERR,"file-->",rewriteUri);
		ngx.req.set_uri(rewriteUri, true);
		do return end;
	end
end

ngx.exit(404)
