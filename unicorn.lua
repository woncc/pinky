local p = require 'pinky'
local json = require 'cjson'
local lfs = require 'lfs'
local posix = require 'posix'

local function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")

   out = unicorn_check_version()
   return json.encode(out)
end

function unicorn_check_version()
   -- get pid Check that the /data/api/var/unicorn.pid
   local out = {
      data =
         {
            current = posix.readlink("/data/api/current");
            master_wd = posix.readlink("/proc/" .. p.trim(p.read_file("/data/api/var/unicorn.pid")) .. "/cwd");
         };
      status =
         {
               value, error = "";
         }
   }

   if out.data.master_wd == out.data.current then
      out.status.value,out.status.error = "OK",""
   else
      out.status.value,out.status.error = "FAIL","Current unicorn master is running from somewhere other than /data/api/current"
   end
   return out
end

return { pinky_main = pinky_main }
