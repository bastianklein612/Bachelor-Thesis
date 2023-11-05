BL = recording{1}.extractTimetable;
BR = recording{2}.extractTimetable;
FL = recording{3}.extractTimetable;
FR = recording{4}.extractTimetable;
ML = recording{5}.extractTimetable;
MR = recording{6}.extractTimetable;

tiledlayout(6,1); 
nexttile;

p1 = area(BL.Time, BL.BL);
p1.FaceColor = 'black';
ax = gca;
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylabel('LBL','fontsize',20);
nexttile;

p2 = area(ML.Time, ML.ML);
p2.FaceColor = 'black';
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylabel('LML', 'fontsize', 20);
nexttile;

p3 = area(FL.Time,FL.FL);
p3.FaceColor = 'black';
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylabel('LFL', 'fontsize', 20);
nexttile;

p4 = area(BR.Time, BR.BR);
p4.FaceColor = 'black';
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylabel('RBL', 'fontsize', 20);
nexttile;

p5 = area(MR.Time, MR.MR);
p5.FaceColor = 'black';
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylabel('RML', 'fontsize', 20);
nexttile;

p6 = area(FR.Time, FR.FR);
p6.FaceColor = 'black';
ax.XAxis.FontSize = 14;
ax.YAxis.FontSize = 14;
ylabel('RFL', 'fontsize', 20);
