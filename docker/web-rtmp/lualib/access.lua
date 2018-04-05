local redis = require "redis_iresty"
local red = redis:new()

local uri = ngx.var.uri;

local hashStr = string.match(uri, "/(.+)%.mp4");
hashStr = "apvideo:" .. hashStr

local realPath = red:get(hashStr)

if not realPath then
	ngx.exit(404)
end

-- true: => 终止执行当前location之后的逻辑, 执行新的rewrite后的location的逻辑
-- false: => 继续执行当前location之后的逻辑, 只不过uri已经被改变
ngx.req.set_uri(realPath, false);
