
function for_each_grid(grid, fn)
    foreach(grid, function(line)
        foreach(line, function(element)
            fn(element)
        end)
    end)
end