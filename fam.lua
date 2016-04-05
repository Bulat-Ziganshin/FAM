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
    alignment1 = "aleft",
    alignment2 = "aright",
    alignment3 = "aright",
    resizematrix = "yes",
    markarea = "not_continuous",
    markmode = "cell",
    markmultiple = "yes",
    markattitle = "no",
    xautohide = "yes",
    yautohide = "yes",
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

function matrix:markedit_cb(l, c, marked)
  self._marked[l] = marked
  self.redraw = "l"..l
end

function matrix:mark_cb(l, c)
  return self._marked[l]
end

function matrix:click_cb(l, c, status)
  if l==0 and iup.isbutton1(status) then
    self["sortsign"..c] = "up"
    self.redraw = "l"..l..":c"..c
  end
end



function matrix:fill (dir_path)
  local files,dirs = get_dir(dir_path)
  self.data = {}
  self._marked = {}
  for i = 1,#files do
    self.data[i] = {files[i],1,2}
    self._marked[i] = 0
  end
  for i = #dirs,1,-1 do
  end
  self.numlin = #self.data
end

matrix:fill(".")

dlg=iup.dialog{matrix; title="FAM" }
dlg:popup()
