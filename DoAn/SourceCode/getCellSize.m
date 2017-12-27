function cellsize=getCellSize(value)
    switch value
       case 1  
           cellsize=8;
       case 2
           cellsize=2;
       case 3
           cellsize=4;
       case 4
           cellsize=8;
       case 5
           cellsize=16;
    end
end