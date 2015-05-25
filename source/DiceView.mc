using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;
using Toybox.Math;


var selectedNum;
var start = true;
var HEIGHT;
var WIDTH;
var hasSelectedNum = false;

class DiceView extends Ui.View {

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        HEIGHT = dc.getHeight();
        WIDTH = dc.getWidth();
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {

        HEIGHT = dc.getHeight();
        WIDTH = dc.getWidth();

    //Draw bottom black, top white
        if(!start){
        	//draw background
	   		dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
	        dc.clear();

	        //draw forground
			dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
			dc.fillRectangle(0, 0, WIDTH, (HEIGHT/3)*2);

			//Handle if the user presses cancel on Num Selector
			if(!hasSelectedNum){
				selectedNum = 6;
				Math.srand(System.getClockTime().sec);
				hasSelectedNum = true;
			}

			//draw roll
	        dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT );
			var roll = (Math.rand() % selectedNum) + 1;
	        dc.drawText((dc.getWidth() / 2), (((dc.getHeight() / 3)*2)/2) - (dc.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT) / 2), Gfx.FONT_NUMBER_THAI_HOT, roll.toString(), Gfx.TEXT_JUSTIFY_CENTER);

	        //draw cue
			dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
	        dc.drawText((dc.getWidth() / 2), HEIGHT - dc.getFontHeight(Gfx.FONT_SMALL) - 1, Gfx.FONT_SMALL, Ui.loadResource(Rez.Strings.Instructions2), Gfx.TEXT_JUSTIFY_CENTER);

	        //draw dice size
			dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
	        dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 3)*2) + 1, Gfx.FONT_LARGE, "d" + selectedNum, Gfx.TEXT_JUSTIFY_CENTER);

		}else{
			View.onUpdate(dc);
			dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
	        dc.drawText((dc.getWidth() / 2), HEIGHT - dc.getFontHeight(Gfx.FONT_SMALL) - 1, Gfx.FONT_SMALL, Ui.loadResource(Rez.Strings.Instructions), Gfx.TEXT_JUSTIFY_CENTER);
		}
	}

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

}

class NPD extends Ui.NumberPickerDelegate {
    function onNumberPicked(value) {

		hasSelectedNum = true;
        selectedNum = value;

       	Math.srand(System.getClockTime().sec);

		//NumberPickerDelegate requests an update on it's exit
    }
}

class InputDelegate extends Ui.BehaviorDelegate{
	function onTap(){
		if(start){
			showNumberPicker(6);
			start = false;

		}
		else
		{
			Ui.requestUpdate();
		}
	}

	function onHold(){
		showNumberPicker(selectedNum);
	}

	function onKey(evt){
		var key = evt.getKey();

		if(key == Ui.KEY_UP){

			if(start){
				showNumberPicker(6);
				start = false;

			}
			else
			{
				Ui.requestUpdate();
			}

		}else if(key == Ui.KEY_DOWN){
			if(!start){
			showNumberPicker(selectedNum);
			}

		}

	}

	function showNumberPicker(defVal){
    	var numPicker = new Ui.NumberPicker( Ui.NUMBER_PICKER_BIRTH_YEAR, defVal );

		Ui.pushView( numPicker, new NPD(), Ui.SLIDE_IMMEDIATE );
    }

}
