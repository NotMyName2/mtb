function sem
disp(datetime("now"));
%% import data

myCsv = 0;
file = 0;

%% period change for testing
firstDate = NaT;
lastDate = NaT;
WarnWrongDate=1
loadedFile = 0
testPeriod = 0

%% compute everything and then just use

firstDate = datetime('12.12.2020 18:30:00', 'InputFormat', 'dd.MM.uuuu HH:mm:ss');
lastDate = datetime('20.12.2020 22:30:30', 'InputFormat', 'dd.MM.uuuu HH:mm:ss');
lastDate.Day-firstDate.Day
%% get clean dates and cumulative sleep
function recalculateAll(src, event)
    %% raw imported data
    dates = flip(myCsv{:, 1}); % dates sorted oldest first
    starts = flip(myCsv{:, 2});
    ends = flip(myCsv{:, 3});
    
    testPeriod = lastDate.Day-firstDate.Day
    CleanDates = NaT(testPeriod,1);
    CleanDateRunner = 1;

    CumTimes = repmat(duration(hours(0)), testPeriod, 1);
    lengthsRunner = 0; %important 0 not 1
    curStarts = NaT(2*(lastDate.Day-firstDate.Day),1);
    curEnds = NaT(2*(lastDate.Day-firstDate.Day),1);
    CRun = 1
    curDur = repmat(duration(hours(0)), testPeriod, 1);
    startsRunner = 1;
    startIndex = (find(dates>=firstDate, 1,'first')) %finds first index in selected interval
    endIndex = (find(dates>=lastDate, 1,'first'))   %finds last index in selected interval 
    x = startIndex;
    lastEnd = datetime('6 9 420', "InputFormat", 'dd M uuuu')
    while x < endIndex
        FIST = string(dates(x))+" "+string(starts(x));
        SEST = string(dates(x))+" "+string(ends(x));
        FI = datetime(FIST, 'InputFormat', 'dd.MM.uuuu HH:mm:ss');
        SE = datetime(SEST, 'InputFormat', 'dd.MM.uuuu HH:mm:ss');
        
        if SE.Hour < FI.Hour %correctly compute midnight
            FI = FI-days(1); 
        end
        
        curStarts(startsRunner) =FI;
        curEnds(startsRunner) = SE;
        startsRunner = startsRunner+1;
        
        if SE.Day ~= lastEnd.Day
            CleanDates(CleanDateRunner) = datetime(string(SE.Day)+" "+string(SE.Month)+" "+string(SE.Year), 'InputFormat', "dd MM uuuu");
            CleanDateRunner = CleanDateRunner+1;
            lengthsRunner = lengthsRunner+1;
            lastEnd = SE;
     
        end
        CumTimes(lengthsRunner)= CumTimes(lengthsRunner)+(SE-FI);
        curDur(CRun) = SE-FI;
        CRun = CRun+1
        x=x+1;
    end
    %CleanDates 
    CumTimes = CumTimes(1:length(CleanDates));% %make length match
    
    curDates = CleanDates;
    curTimes = CumTimes;
    curStarts= curStarts(~isnat(curStarts));
    curEnds = curEnds(~isnat(curEnds));
    
%     %% pattern
% 
%     %draw rectangles lmao
% 
%% sleep
    curStarts
    dayParts = 0:1:23;
    curSleep = zeros(24, 1);
    for B = 1:size(dayParts,2)-1-1
        curSleep(B) = length(curStarts((curStarts.Hour >= B) & (curStarts.Hour < B+1)));
    end
    curSleep
    %setappdata(myFig, 'sleepData', sleepCount)
    
    %% wake
    dayParts = 0:1:23;
    curWake = zeros(24, 1);
    for B = 1:size(dayParts,2)-1-1
        disp(B)
        curWake(B) = length(curEnds((curEnds.Hour >= B) & (curEnds.Hour < B+1)));
    end
end

%% launch gui
GUIstartX = 200; 
GUIstartY = 200;
GUIstartWidth = 600;
GUIstartHeight = 400;
myFig = uifigure('Name', 'yeet', ...
    'Position', [GUIstartX, GUIstartY, GUIstartWidth, GUIstartHeight]);

%uiaxes settings
sidePadding = 0.05*GUIstartWidth;
bottomPadding = 0.2*GUIstartHeight;
axesWidth = 0.9*GUIstartWidth;
axesHeight = 0.8*GUIstartHeight;
dataLen = testPeriod

myAxes = uiaxes(myFig, ...
    'Position', [sidePadding, bottomPadding, axesWidth,  axesHeight], ...
    'YAxisLocation', 'left', 'Xlim', [1 2], 'Ylim', [0 13], ...
    'Xgrid', 'on', 'Ygrid', 'on');
%    'UserData', nan(1,dataLen));


%% top kek
curDates = NaT
curStarts = duration(hours(0))
curEnds = duration(hours(0))
curTimes = duration(hours(0))
curSleep = duration(hours(0))
curWake = duration(hours(0))
%myFig = uifigure('Name', 'yeet', ...
%    'Position', [startX, startY, startWidth, startHeight]);
myButtonsGroup = uibuttongroup(myFig, 'Position', [10, 10, 380, 40]);
disp(myButtonsGroup.Buttons)

B1 = uiradiobutton(myButtonsGroup, 'position', [10 10 60 20], 'text', 'wake');
B2 = uiradiobutton(myButtonsGroup, 'position', [70 10 60 20], 'text', 'sleep');
B3 = uiradiobutton(myButtonsGroup, 'position', [130 10 60 20], 'text', 'trend');
B4 = uiradiobutton(myButtonsGroup, 'position', [190 10 60 20], 'text', 'debt');
B5 = uiradiobutton(myButtonsGroup, 'position', [250 10 60 20], 'text', 'pattern');
B6 = uiradiobutton(myButtonsGroup, 'position', [320 10 60 20], 'text', 'stats');
buttonVector = [B1, B2, B3, B4, B5, B6];
B7 = uibutton(myFig, 'position', [420 40 100 30], 'text', 'recalculate',...
    'ButtonPushedFcn', @B7Recalc, 'enable', 'off');
    function B7Recalc(src, event)
        disp("B7 recalc")
        recalculateAll()
        printButVec(myButtonsGroup, 'lmao', buttonVector)
    end

D1 = uidatepicker(myFig, 'position', [400 10 100 20], ...
                    'displayformat', 'dd.MM.uuuu', ...
                    'ValueChangedFcn', @D1DateChangeFcn)
D2 = uidatepicker(myFig, 'position', [500 10 100 20], ...
                        'displayformat', 'dd.MM.uuuu',...
                        'ValueChangedFcn', @D2DateChangeFcn)
    function D1DateChangeFcn(src, event)
        disp("D1 date change")
        toSet = datetime(src.Value, 'InputFormat', 'dd.MM.uuuu');
        firstDate = toSet;
    end

    function D2DateChangeFcn(src, event)
        toSet = datetime(src.Value, 'InputFormat', 'dd.MM.uuuu');
        lastDate=toSet;
    
    end
myButtonsGroup.SelectionChangedFcn = {@printButVec, buttonVector};

%M1 = uimenu('Text','Options');
M1 = uimenu(myFig,'Text','File');
M1.MenuSelectedFcn = {@MenuSelected};
 
    function MenuSelected(src,event)
        file = uigetfile('*.csv');
        if file == 0
            msgbox("Cancelled file import, please try again");
        elseif file(end-3:end)~= ".csv"
           msgbox("Failed to import file, please select .csv file")
        else
        myCsv = readtable(file);
        loadedFile = 1
        B7.Enable = 'on'
        end
        
    end
 

%% todo 
%   gui lmao
%   length vs date
%   pattern
%   add background nebo labels aby urcil, jake obdobi zivota to bylo
%  

%
%% buttonFunctions

function printButVec(src, lmao, butVec)

    parFig = src.Parent;
    if  butVec(1).Value == 1
        disp("displaying wake")
        nowData = curWake;
        nowXAxis = 0:23;
        disp("data len "+string(length(nowData)));
        disp("axis len"+string(length(nowXAxis)));
        xtickformat(parFig.CurrentAxes, 'auto');
        bar(parFig.CurrentAxes, nowXAxis, nowData);
    end
    if butVec(2).Value == 1
        disp("displaying sleep")
        nowData = curSleep;
        nowXAxis = 0:23;
        disp("data len "+string(length(nowData)));
        disp("axis len"+string(length(nowXAxis)));
        xtickformat(parFig.CurrentAxes, 'auto');
        bar(parFig.CurrentAxes, nowXAxis, nowData);
    end
    if butVec(3).Value == 1
        disp("displaying trend")
        nowData = curTimes;
        nowXAxis = curDates;
        disp("data len "+string(length(nowData)));
        disp("axis len"+string(length(nowXAxis)));
        xtickformat(parFig.CurrentAxes, 'auto')
        plot(parFig.CurrentAxes, nowXAxis, nowData);
    end
end


end