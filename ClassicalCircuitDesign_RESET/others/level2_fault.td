Header (
	company("EMA Design Automation") 
	product("TimingDesigner") 
	rev("9.103") 
	file("c:\\users\\zhxiaoq9\\desktop\\reset\\level2_fault.td") 
	date("01/13/2018") time("12:25") 
	format("9.0") 
	baseScale(1000.000000) 
	zoomFactor("0.00333579") 
	zoomBegin(0) 
	zoomEnd(127241) 
	simHDL(Verilog) 
	simDelayMechanism(Transport) 
	nextID(11) 
	TimingAnalysisMethod(51) 
	
	generalPrintParams( "printer,,,portrait,clipboard,Letter,default,6,5,in,color,scaleable,mifframe,preview,")
	diagramPrintParams( "0,2147483647,0,-1,true,true,1,1,true,true,true,true,all,diagramEnd")
	spreadsheetPrintParams( "0,2147483647,true,false,1,true,all")
	)
HDLHeader( 
	hdlFile("") 
	checkConstraints(true) 
	comment("") 
	checkTimeout(never) 
	
	command( name("syn_reg_fault") cmdType(null) ))
DefaultLabel(
	delay(showNameString,"") 
	constraint(showNameString,"") 
	guarantee(showNameString,"") 
	measure(showMeasure,"") 
	store(showNameString,"") 
	wait(showNameString,"") 
	end(showNameString,"") 
	boundary(showIncrement,"") 
	loop(showNameString,"") 
	waveform(showSkip,"","") 
	specifiedclock(showSkip,"","") 
	derivedclock(showSkip,"","") 
	simwaveform(showSkip,"","") 
	bus(showValue,"","H") 
	)
DiagramStyle (
	waveformFont(winFont("Arial",100) qtFont("Arial",9) ) 
	rulerFont(winFont("Arial",100) qtFont("Arial",9) ) 
	relationshipFont(winFont("Arial",100) qtFont("Arial",9) ) 
	labelFont(winFont("Arial",100) qtFont("Arial",9) ) 
	annotationFont(winFont("Arial",100) qtFont("Arial",8) ) 
	slotHeight("11") 
	edgeHeight("11") 
	edgeGrade("1.96261") 
	inputPenStyle(0) 
	outputPenStyle(0) 
	inoutPenStyle(0) 
	internalPenStyle(0) 
	vRelationshipPenStyle(0) 
	hRelationshipPenStyle(0) 
	inputPenColor(3) 
	outputPenColor(3) 
	inoutPenColor(3) 
	internalPenColor(3) 
	wavePenWidth("0") 
	relationshipPenWidth("0") 
	wavesOnTop 
	relationshipsOnTop 
	annotationsOnTop 
	showSlopedEdges 
	edgeDisplayType(Uncertainty) 
	)
Clock ( objectID(2) name("clk") minheight("0") periodScale(1000.000) period(10.000000) dutyCycle(50.000000) DiagramStyle (
	waveformFont(winFont("Arial",100) qtFont("Arial",9) ) 
	rulerFont(winFont("Arial",100) qtFont("Arial",9) ) 
	relationshipFont(winFont("Arial",100) qtFont("Arial",9) ) 
	labelFont(winFont("Arial",100) qtFont("Arial",9) ) 
	annotationFont(winFont("Arial",100) qtFont("Arial",8) ) 
	slotHeight("11") 
	edgeHeight("11") 
	edgeGrade("1.88073") 
	inputPenStyle(0) 
	outputPenStyle(0) 
	inoutPenStyle(0) 
	internalPenStyle(0) 
	vRelationshipPenStyle(0) 
	hRelationshipPenStyle(0) 
	inputPenColor(3) 
	outputPenColor(3) 
	inoutPenColor(3) 
	internalPenColor(3) 
	wavePenWidth("0") 
	relationshipPenWidth("0") 
	wavesOnTop 
	relationshipsOnTop 
	annotationsOnTop 
	edgeDisplayType(Uncertainty) 
	)

	hdl( direction(input) ) label(showDefault,"","H") )
Waveform ( objectID(3) name("rst_n") minheight("0") edges(
	(low,0.000,0.000,L), 
	(high,15000.000,15000.000), 
	(low,138000.000,138000.000), 
	(blank,140138.000,140138.000)) 
	hdl( direction(input) ) label(showDefault,"","H") )
Waveform ( objectID(7) name("rst_n_d1_reg") minheight("0") edges(
	(low,0.000,0.000,L), 
	(high,17000.000,17000.000), 
	(low,138000.000,138000.000), 
	(blank,140138.000,140138.000)) 
	hdl( direction(input) ) label(showDefault,"","H") )
Waveform ( objectID(5) name("rst_n_d1_reg_Q") minheight("0") edges(
	(low,0.000,0.000,L), 
	(high,20000.000,20000.000), 
	(blank,140138.000,140138.000)) 
	hdl( direction(internal) ) label(showDefault,"","H") )
Waveform ( objectID(8) name("rst_n_syn_reg") minheight("0") edges(
	(low,0.000,0.000,L), 
	(high,20000.000,20000.000), 
	(low,138000.000,138000.000), 
	(blank,140138.000,140138.000)) 
	hdl( direction(internal) ) label(showDefault,"","H") )
Waveform ( objectID(4) name("rst_n_syn_reg_Q(D value)") minheight("0") edges(
	(low,0.000,0.000,L), 
	(high,30000.000,30000.000), 
	(low,152000.000,152000.000), 
	(blank,153425.000,153425.000)) 
	hdl( direction(output) ) label(showDefault,"","H") )
Waveform ( objectID(9) name("rst_n_syn_reg_Q(reset value)") minheight("0") edges(
	(low,0.000,0.000,L), 
	(high,41000.000,41000.000), 
	(low,152000.000,152000.000), 
	(blank,153425.000,153425.000)) 
	hdl( direction(output) ) label(showDefault,"","H") )
Grid ( "clk" topWave("clk") 
	 color(12) 1stWidth(0) 2ndWidth(0) 1stStyle(0) 2ndStyle(0) 
  show1st show2nd )

CauseAndEffect(objectID(10) source("rst_n_d1_reg_Q",1) target("rst_n_syn_reg_Q(D value)",1) name("D value") label(showDefault,"") fromLatestEnd toEarliestBegin color(3) width("0")  )
EndCycleEvent ( objectID(1) name("end") time(407.462292) showVert hideOnPrinter label(showDefault,"") fromLatestEnd toEarliestBegin  )
