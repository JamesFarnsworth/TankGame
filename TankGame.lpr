program TankGame;
{$mode objfpc}{$H+}

uses
  SysUtils,
  crt,
  Classes;

{$R *.res}

var
  XPosShotsP1, YPosShotsP1, XPosShotsP2, YPosShotsP2: array of integer;
  P1numofshots, P2numofshots, Count, num_p1_z_pressed, num_p2_z_pressed, winner: integer;
  P1YPos, P2YPos: integer;              //winner is 0 if there is currently no winner, 1 if p1 has won, 2 if p2 has won, and 3 if it is a stalemate
  userkey: char;
  p1lowestallowed, p1highestallowed, p2lowestallowed, p2highestallowed: integer;
  exit: boolean;
  exit2: string;
const
  p1highestbulletallowed: integer = 27;
  p2highestbulletallowed: integer = 4;
begin
    clrscr;
    cursoroff;
    gotoxy(windmaxX div 2 - (31 div 2), 2);
    Write('Tank Game - by James Farnsworth');
    gotoxy(1, 4);
    Write('The aim of the game is to shoot the opposing tank. You could try and do this by');
    gotoxy(1, 5);
    Write('shooting them outright, but this is hard. Instead you can trap them as tanks');
    gotoxy(1, 6);
    Write('cannot drive over shells, then try to shoot them. Player 1 uses the ''W'' key');
    gotoxy(1, 7);
    Write('to  move up, the ''S'' or ''A'' keys to move down, and the ''Z'' key to shoot.');
    gotoxy(1, 8);
    Write('Player 2 uses the ''I'' key to move up, the ''J'' or ''K'' keys to move down,');
    gotoxy(1, 9);
    Write('and the ''M'' key  to shoot. To be able to shoot, you must first reload by');
    gotoxy(1, 10);
    Write('pressing the ''shoot'' key 3 times. (P1 is on the left and P2 is on the right)');
    readln;
    repeat
      clrscr;
      exit := False;
      winner := 0;
      exit2 := '-';
      p1lowestallowed := windmaxy;
      p2lowestallowed := windmaxy;
      p1highestallowed := 1;
      p2highestallowed := 1;
      p1highestbulletallowed := 27;
      p2highestbulletallowed := 4;
      P1YPos := windmaxY div 2;
      P2YPos := windmaxY div 2;
      clrscr;
      gotoXY(4, P1YPos);
      Write(chr(177), chr(177), chr(177), '-');
      gotoXY(24, P2YPos);
      Write('-', chr(177), chr(177), chr(177));
      p1numofshots := 0;
      p2numofshots := 0;
      setlength(xposshotsp2, p2numofshots + 1);
      setlength(yposshotsp2, p2numofshots + 1);
      setlength(xposshotsp1, p1numofshots + 1);
      setlength(yposshotsp1, p1numofshots + 1);
      for Count := 1 to windmaxY do
      begin
        gotoXY(15, Count);
        Write('|');
      end;
      repeat
        if keypressed then
          userkey := readkey
        else
          userkey := '#';  //A value that is not used
        //p1's controls
        if (userkey = 'w') and (P1YPos > p1highestallowed) then
        begin
          gotoXY(4, P1YPos);
          Write('    ');
          P1YPos := P1YPos - 1;
          gotoXY(4, P1YPos);
          Write(chr(177), chr(177), chr(177), '-');
        end;
        if ((userkey = 'a') or (userkey = 's')) and (P1YPos < p1lowestallowed) then
        begin
          gotoXY(4, P1YPos);
          Write('    ');
          Inc(P1YPos);
          gotoXY(4, P1YPos);
          Write(chr(177), chr(177), chr(177), '-');
        end;
        if (userkey = 'z') then
        begin
          Inc(num_p1_z_pressed);
          if (num_p1_z_pressed mod 4 = 0) then
          begin
            Inc(P1numofshots);
            setlength(XPosShotsP1, P1numofshots);
            setlength(YPosShotsP1, P1numofshots);
            YposshotsP1[P1numofshots - 1] := P1Ypos;
            Xposshotsp1[p1numofshots - 1] := 8;
          end;
        end;
        //p2's controls
        if (userkey = 'i') and (P2YPos > p2highestallowed) then
        begin
          gotoXY(24, P2YPos);
          Write('    ');
          P2YPos := P2YPos - 1;
          gotoXY(24, P2YPos);
          Write('-', chr(177), chr(177), chr(177));
        end;
        if ((userkey = 'j') or (userkey = 'k')) and (P2YPos < p2lowestallowed) then
        begin
          gotoXY(24, P2YPos);
          Write('    ');
          Inc(P2YPos);
          gotoXY(24, P2YPos);
          Write('-', chr(177), chr(177), chr(177));
        end;
        if (userkey = 'm') then
        begin
          Inc(num_p2_z_pressed);
          if (num_p2_z_pressed mod 4 = 0) then
          begin
            Inc(P2numofshots);
            setlength(XPosShotsP2, P2numofshots);
            setlength(YPosShotsP2, P2numofshots);
            YposshotsP2[P2numofshots - 1] := P2Ypos;
            Xposshotsp2[p2numofshots - 1] := 23;
          end;
        end;
        //MOVE SHELLS ON
        if (p1numofshots > 0) then
        begin
          for Count := 0 to P1numofshots - 1 do
          begin
            //Go to previous position of shell
            gotoXY(xposshotsp1[Count] - 1, yposshotsp1[Count]);
            if (WhereX > 7) and (wherex < 27) then  //Do not destroy own gun!
              Write(' ');  //Delete shell from previous position
            gotoXY(xposshotsp1[Count], yposshotsp1[Count]);
            if WhereX <= p1highestbulletallowed then
            begin
              Write('-');
              Inc(XPosShotsP1[Count]);
            end;
          end;

        end;
        if (p2numofshots > 0) then
        begin
          for Count := 0 to P2numofshots - 1 do
          begin
            //Go to previous position of shell
            gotoXY(xposshotsp2[Count] + 1, yposshotsp2[Count]);
            if (xposshotsp2[Count] < 23) and (xposshotsp2[Count] > 3) then
              //Do not destroy own gun!
              Write(' ');  //Delete shell from previous position
            gotoXY(xposshotsp2[Count], yposshotsp2[Count]);
            if xposshotsp2[Count] >= p2highestbulletallowed then
            begin
              Write('-');
              XPosShotsP2[Count] := XPosShotsP2[Count] - 1;
            end;
          end;
        end;
        for Count := 1 to windmaxY do
        begin
          gotoXY(15, Count);
          Write('|');
        end;
        //end of game or lowest player can go logic
        if (p1numofshots > 0) then
        begin
          for Count := 0 to p1numofshots do
          begin
            if ((xposshotsp1[Count] = p1highestbulletallowed) and
              (yposshotsp1[Count] > P2ypos)) and (yposshotsp1[Count] <= p2lowestallowed) then
            begin
              p2lowestallowed := yposshotsp1[Count] - 1;
            end;
            if ((xposshotsp1[Count] = p1highestbulletallowed) and
              (yposshotsp1[Count] < P2ypos)) and (yposshotsp1[Count] >= p2highestallowed) then
            begin
              p2highestallowed := yposshotsp1[Count] + 1;
            end;
            if (xposshotsp1[Count] = p1highestbulletallowed) and
              (yposshotsp1[Count] = p2ypos) then
            begin
              exit := True;
              winner := 1;
            end;
          end;
        end;
        if (p2numofshots > 0) then
        begin
          for Count := 0 to p2numofshots do
          begin
            if ((xposshotsp2[Count] = p2highestbulletallowed) and
              (yposshotsp2[Count] > P1ypos)) and (yposshotsp2[Count] <= p1lowestallowed) then
            begin
              p1lowestallowed := yposshotsp2[Count] - 1;
            end;
            if ((xposshotsp2[Count] = p2highestbulletallowed) and
              (yposshotsp2[Count] < p1ypos)) and (yposshotsp2[Count] >= p1highestallowed) then
            begin
              p1highestallowed := yposshotsp2[Count] + 1;
            end;
            if (xposshotsp2[Count] = p2highestbulletallowed) and
              (yposshotsp2[Count] = p1ypos) then
            begin
              exit := True;
              winner := 2;
            end;
          end;
        end;
        if (p1highestallowed > p2lowestallowed) or (p2highestallowed > p1lowestallowed) then
        begin
          exit := True;
          winner := 3;
        end;
        sleep(50);
      until (exit);
      if (winner = 1) then
      begin
        clrscr;
        gotoxy((windmaxx div 2) - 10, (windmaxy div 2) - 1);
        Write('####################');
        gotoxy((windmaxx div 2) - 10, windmaxy div 2);
        Write('      P1 wins!      ');
        gotoxy((windmaxx div 2) - 10, (windmaxy div 2) + 1);
        Write('####################');
      end;
      if (winner = 2) then
      begin
        clrscr;
        gotoxy((windmaxx div 2) - 10, (windmaxy div 2) - 1);
        Write('####################');
        gotoxy((windmaxx div 2) - 10, windmaxy div 2);
        Write('      P2 wins!      ');
        gotoxy((windmaxx div 2) - 10, (windmaxy div 2) + 1);
        Write('####################');
      end;
      if (winner = 3) then
      begin
        clrscr;
        gotoxy((windmaxx div 2) - 10, (windmaxy div 2) - 1);
        Write('####################');
        gotoxy((windmaxx div 2) - 10, windmaxy div 2);
        Write('     Stalemate!     ');
        gotoxy((windmaxx div 2) - 10, (windmaxy div 2) + 1);
        Write('####################');
      end;
      sleep(3000);
      repeat
        clrscr;
        exit2 := '-';
        gotoxy((windmaxx div 2) - 10, windmaxy div 2);
        Write('Play it again? [y/n] ');
        readln(exit2);
      until (uppercase(exit2) = 'N') or (uppercase(exit2) = 'Y');
      for Count := 0 to p1numofshots - 1 do
      begin
        xposshotsp1[Count] := 0;
        yposshotsp1[Count] := 0;
      end;
      for Count := 0 to p2numofshots - 1 do
      begin
        xposshotsp2[Count] := 0;
        yposshotsp2[Count] := 0;
      end;
    until (uppercase(exit2) = 'N');
end.
