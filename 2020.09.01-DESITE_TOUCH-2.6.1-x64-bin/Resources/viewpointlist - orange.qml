import QtQuick 1.1


Rectangle {
     
    // width: 400
    /* height: parent.height */

    color: "white";
 
    Component {
         
		 id: contactDelegate
         
		 Item {			
             
            width: 160; height: 150
			x: 30;

            property color textColor: "black";

            Column {

                spacing: 2;
				x: 10;
				y: 10;	

                Text {
                    id: textName;
                    font.family: "Swiss721 Lt BT";
                    font.pointSize: 12;
                    text: vpName;
                    color: textColor;
                }

				Image { 
					cache: false;
					source: "image://vp/" + index 
				}
				 
                /*Text {
                    text: '<b>Index:</b> ' + index
                    color: textColor;
                }*/

            }

            onFocusChanged: {
                if( focus == false ){
                    textColor = "black";
                } else {
					textColor = "white";
				}
            }

            MouseArea{

                 id: buttonMouseArea

                 anchors.fill: parent
                 //onClicked handles valid mouse button clicks

                 onClicked: {
                     // console.log(name + " clicked, index = " + index )
                     listView.currentIndex = index;
                     listView.currentItem.textColor = "white";
                     myModel.showViewpoint(index);
                 }

             }
			              
			 
         }
     }
	 
    Component {

        id: highlight

        Rectangle {

            width: listView.width - 60
            height: 50
            x: 30;
            color: '#d49e2c'; 
            radius: 3;
            // border.color: "black";
            border.width: 0;

            /*smooth: true; */
            y: list.currentItem.y
            Behavior on y {
                SpringAnimation {
                    spring: 30
                    damping: 0.2
                }
            }

        }


    }
 			
    ListView {

        id: listView;
        width: parent.width
        height: 600

        anchors {
            top: parent.top;
            topMargin: 5;
            bottom: parent.bottom;
        }


        clip: true;

        model: myModel; // ContactModel {} /* myModel */
        delegate: contactDelegate
       
        highlight: highlight
        highlightFollowsCurrentItem: true
        highlightMoveSpeed: 9999999
        // highlightMoveDuration: 1
        focus: true


    }
	
    ScrollBar {
        scrollArea: listView; 
		height: listView.height; 
		width: 8
        anchors.right: listView.right
    }

 }
 
