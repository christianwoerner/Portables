// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

Rectangle {

    // anchors.left: parent.left
    color: 'white';

    Component {

        id: contactDelegate

        Item {

            width: grid.cellWidth-5; height: grid.cellHeight-5

            Row {

                anchors.fill: parent
                anchors.margins: 10

                Column {
                    id: col
                    Image {
                        id: buildingPic                        
						source: 'qrc:/desiteTouch/Resources/office_building_sw_64x64.png';						
                        // source: 'qrc:/desiteTouch/Resources/office_building_128x128.png';
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Column {
				
                    Text {
                        text: prjName;
                        font.pointSize: 10
                        font.bold: true
                        font.family: "Swiss721 Lt BT";
                        // anchors.left: col.right; // parent.horizontalCenter
						// color: textColor;
                    }

                    Text {                        
						text: prjPath;
                        font.family: "Swiss721 Lt BT";
                        font.pointSize: 8                        
                    }

                    Text {
                        text: prjLastOpened;
                        font.family: "Swiss721 Lt BT";
                        font.pointSize: 8
                    }
					
					Text {
                        text: prjPos;
                        font.family: "Swiss721 Lt BT";
                        font.pointSize: 8
                    }
					
                }
            }			
			
            MouseArea{

                id: buttonMouseArea

                // anchors.fill: parent
                //onClicked handles valid mouse button clicks
                width: parent.width - 70
                height: parent.height - 40

                onClicked: {
                    // console.log(name + " clicked, index = " + index )
                    grid.currentIndex = index;
                    // grid.currentItem.scale = 2;
                    projectListModel.showProject(index);
                    // mouse.accepted = false;
                }

            }


        }


    }


    GridView {

        id: grid

        width: parent.width
        height: parent.height
        cacheBuffer: 0

        flow: GridView.TopToBottom

        model: projectListModel

        anchors.top: parent.top
        anchors.left: parent.left

        cellWidth: 540;
        cellHeight: 124; // if(height > 400 ) { height / 3 } else { height / 2 }

        delegate: contactDelegate
			
        highlight: Item {
			
				
            Rectangle {
                anchors.fill: parent
                color:  '#d49e2c'; 
				radius: 0			
            }

            Rectangle {
                id: rRR
                color:  "#000000"
                width: 80
                height: 30
                radius: 3
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                anchors.margins: 5
                Text {
                    text: 'OPEN';
                    font.family: "Swiss721 Lt BT"
                    font.pointSize: 12
                    // font.bold: true;
                    color: "#ffffff"
                    anchors.centerIn: parent
                }

            }
		
			Rectangle {
                id: removePrjRect
                color:  "#220000"
                width: 80
                height: 30
                radius: 3
                anchors.left: parent.left;
                anchors.bottom: parent.bottom;
                anchors.margins: 5
				
                Text {
                    text: 'REMOVE';
                    font.family: "Swiss721 Lt BT"
                    font.pointSize: 12
                    // font.bold: true;
                    color: "#ffffff"
                    anchors.centerIn: parent
                }

            }

			MouseArea{

                id: buttonMouseAreaRemoveProject

                width: 80
                height: 30

                anchors.left: parent.left;
                anchors.bottom: parent.bottom;
                anchors.margins: 5

                onClicked: {
                    projectListModel.removeProject(grid.currentIndex);                    
                }

            }

            MouseArea{

                id: buttonMouseAreaOpenProject

                width: 80
                height: 30

                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                anchors.margins: 5

                onClicked: {
                    projectListModel.openProject(grid.currentIndex);
                }

            }

			
			
        }

        highlightFollowsCurrentItem: true
        focus: true

    }

}
