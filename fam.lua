require 'iuplua'
require 'iupluacontrols'
require 'lfs'

function get_dir (dir_path)
  local files = {}
  local dirs = {}
  for f in lfs.dir(dir_path) do
    if f ~= '.' and f ~= '..' then
      if lfs.attributes(dir_path..'/'..f,'mode') == 'file' then
        table.insert(files,f) 
      else
        table.insert(dirs,f)
      end
    end
  end
  return files,dirs
end



matrix = iup.matrix
{
    numlin=0,
    numcol=3,
    height0=10,
    widthdef=30,
    width1=100,
}

function matrix:value_cb(l, c) 
  if c == 0 then
    return nil--"title"
  end
  if l == 0 then --"title"
    local t = {"Filename","Size","Date"}
    return (t[c])
  end
  return self.data[l][c]
end

function matrix:fill (dir_path)
  local files,dirs = get_dir(dir_path)
  self.data = {}
  for i = 1,#files do
    self.data[i] = {files[i],1,2}
  end
  for i = #dirs,1,-1 do
  end
  self.numlin = #self.data
end

matrix:fill(".")

dlg=iup.dialog{matrix; title="FAM" }
dlg:popup()

