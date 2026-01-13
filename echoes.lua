
-- ty nerdy teachers!
-- https://nerdyteachers.com/PICO-8/Guide/echo

echoes = {}


-- store a value to be printed
function echo(val)
  add(echoes,tostr(val))
end

-- print all echoes
-- ...opt: c (text color, default: latest)
-- ...opt: x,y (print coords)
function print_echoes(c, x, y)
	local cx, cy, cc = cursor()  --pen_x, pen_y, pen_color

	--set text position and color
	cursor(x or cx, y or cy, c or cc)
	for i=1,#echoes do
		print(tostr(echoes[i]))
	end

	--erase all echoes
	echoes = {}
end

-- optional: label (header caption)
function echo_tbl(tbl, label)
	if type(tbl) == "table" then
		add(echoes,"--")
		add(echoes,"[ " .. (label or "unlabeled") .. " ]")
		add(echoes,"")
		--
		for k,v in pairs(tbl) do
			add(echoes,("+ " .. k .. ": " .. tostr(v)))
		end
		--
		add(echoes,"--")
	end
end

-- my own extension
debug_gfx = {}

function add_debug_gfx(fn)
    add(debug_gfx, fn)
end

function draw_debug_gfx()
    foreach(debug_gfx, function(fn)
        if fn then fn() end
    end)
    debug_gfx = {}
end