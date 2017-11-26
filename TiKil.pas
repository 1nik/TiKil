PROGRAM TiKil(input,output);
TYPE
    tRow = array[1..128] of char;
    tBoard = array[1..128] of tRow;
VAR
    board: tBoard;
    testRow: tRow;
    i,j,iCoord,jCoord,iTrueCoord,jTrueCoord,size,hSize,vSize,menu:integer;
PROCEDURE mainMenu (var opcion : integer);
BEGIN
    writeln('Welcome to TiKil, the Time Killer Game.');
    writeln('Input 1 to Start or 0 to quit.);
    read (option);
END;
PROCEDURE chooseSize;
BEGIN
    writeln('Introduce the desired size of the playing board.');
    writeln('Sizes up to 32 are supported.');
    write('Size: ');
    read(size);
    IF ((size>1) AND (size<33))
    THEN
    BEGIN
        hSize:=4*size-3;
        vSize:=2*size-1;
    END
    ELSE
        BEGIN
            writeln('The chosen size is invalid, please choose a sensible size.');
            chooseSize;
        END;
END;
PROCEDURE resetRow(VAR thisRow: tRow);
BEGIN
    FOR j:=1 TO size DO thisRow[1+4*(j-1)]:='o';
    FOR j:=1 TO size-1 DO
    BEGIN
        thisRow[2+4*(j-1)]:=' ';
        thisRow[3+4*(j-1)]:=' ';
        thisRow[4+4*(j-1)]:=' ';
    END;
END;
PROCEDURE blankRow(VAR thisRow: tRow);
BEGIN
    FOR j:=1 TO hSize DO thisRow[j]:=' ';
END;
PROCEDURE resetBoard(VAR thisBoard: tBoard);
(*resetBoard has to use a different variable than resetRow and blankRow as a counter.
If not, Pascal uses the wrong counter inside resetRow and freezes.
This behaviour is the same in printBoard.
The outermost layer (resetBoard) uses i, then the inner will use j, k etc. *)
BEGIN
    FOR i:=1 TO size DO resetRow(thisBoard[1+2*(i-1)]);
    FOR i:=1 TO size DO blankRow(thisBoard[2+2*(i-1)]);
END;
PROCEDURE printRow(thisRow: tRow);
BEGIN
    FOR j:=1 TO hSize DO write(thisRow[j]);
    writeln;
END;
PROCEDURE printBoard(VAR thisBoard: tBoard);
BEGIN
    FOR i:=1 TO vSize DO printRow(thisBoard[i]);
END;
PROCEDURE printBoardWithGuides(VAR thisBoard: tBoard);
BEGIN
    write('            ');
    FOR i:=1 TO size*2-1 DO (*Write the tens*)
    BEGIN
        IF i div 10 <> 0 THEN write(i div 10);
        write(' ');
    END;
    writeln;
    write(' ij');
    FOR i:=1 TO size*2-1 DO (*Write the units*)
    BEGIN
        write (i mod 10);
        write(' ');
    END;
    writeln;

    FOR i:=1 TO vSize DO
    BEGIN
        IF i<10 THEN write(' ');
        write(i);
        write(' ');
        printRow(thisBoard[i]);
    END;
    writeln;
END;
PROCEDURE userInput(VAR thisBoard: tBoard); FORWARD;
PROCEDURE inputErrorMessage(VAR thisBoard: tBoard);
BEGIN
    writeln('The values introduced are invalid.');
    writeln;
    printBoardWithGuides(thisBoard);
    userInput(thisBoard);
END;
PROCEDURE userInput(VAR thisBoard: tBoard);
(* It is not protected against negative numbers, reals, chars or strings.*)
BEGIN
    writeln('Please introduce the i and j values separated by a space, or 0 to quit.');
    read(iCoord);
    IF iCoord=0 THEN halt;
    read(jCoord);
    iTrueCoord:=iCoord;
    jTrueCoord:=jCoord*2-1;
    IF thisBoard[iTrueCoord,jTrueCoord]=' '
    THEN
        BEGIN
        IF (jCoord MOD 2 = 0) AND (iCoord MOD 2 = 1)
        THEN thisBoard[iTrueCoord,jTrueCoord]:='-'
        ELSE
            IF (iCoord MOD 2 = 0) AND (jCoord MOD 2 = 1)
            THEN thisBoard[iTrueCoord,jTrueCoord]:='|'
            ELSE
            inputErrorMessage(thisBoard);
        END
    ELSE inputErrorMessage(thisBoard);
END;

BEGIN
    FOR i:=1 TO 5 DO writeln;
    chooseSize;
    resetBoard(board);
    printBoardWithGuides(board);
    WHILE i<> 9999 DO BEGIN
        userInput(board);
        printBoardWithGuides(board);
    END;
END.
