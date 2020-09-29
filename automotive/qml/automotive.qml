/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.10
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Imagine 2.12
import QtQuick.Window 2.0
import QtQuick.Controls.impl 2.3
import QtQuick 2.9
import QtQuick.Window 2.2




ApplicationWindow {
    id: window
    width: 1280
    height: 720
    color: "#000000"
    minimumWidth: 1180
    minimumHeight: 663
    visible: true
    title: "Qt Quick Controls 2 - Imagine Style Example: Automotive"

    readonly property color colorGlow: "#1d6d64"
    readonly property color colorWarning: "#d5232f"
    readonly property color colorMain: "#6affcd"
    readonly property color colorBright: "#ffffff"
    readonly property color colorLightGrey: "#888"
    readonly property color colorDarkGrey: "#333"

    readonly property int fontSizeExtraSmall: Qt.application.font.pixelSize * 0.8
    readonly property int fontSizeMedium: Qt.application.font.pixelSize * 1.5
    readonly property int fontSizeLarge: Qt.application.font.pixelSize * 2
    readonly property int fontSizeExtraLarge: Qt.application.font.pixelSize * 5

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    Frame {
        id: frame
        anchors.rightMargin: 90
        anchors.bottomMargin: 90
        anchors.leftMargin: 90
        anchors.topMargin: 90
        anchors.fill: parent
        anchors.margins: 90

        RowLayout {
            id: mainRowLayout
            anchors.fill: parent
            anchors.margins: 24
            spacing: 36

            Container {
                id: leftTabBar
                Layout.bottomMargin: 200
                Layout.topMargin: 0

                currentIndex: 1

                Layout.fillWidth: false
                Layout.fillHeight: false

                ButtonGroup {
                    buttons: columnLayout.children
                }

                contentItem: ColumnLayout {
                    id: columnLayout
                    spacing: 3

                    Repeater {
                        model: leftTabBar.contentModel
                    }
                }

                FeatureButton {
                    id: navigationFeatureButton
                    text: qsTr("Navigation")
                    icon.name: "navigation"
                    Layout.fillHeight: true
                }

                FeatureButton {
                    width: 60
                    height: 78
                    text: qsTr("Music")
                    icon.name: "music"
                    checked: true
                    Layout.fillHeight: true
                }

                FeatureButton {
                    text: qsTr("Message")
                    icon.name: "message"
                    Layout.fillHeight: true
                }
            }

            StackLayout {
                currentIndex: leftTabBar.currentIndex

                Layout.preferredWidth: 150
                Layout.maximumWidth: 150
                Layout.fillWidth: false

                Item { id: element1}

                ColumnLayout {
                    spacing: 16

                    ButtonGroup {
                        id: viewButtonGroup
                        buttons: viewTypeRowLayout.children
                    }

                    RowLayout {
                        id: viewTypeRowLayout
                        spacing: 3

                        Layout.bottomMargin: 12

                        Button {
                            id: button
                            text: qsTr("Compact")
                            font.pixelSize: fontSizeExtraSmall
                            checked: true

                            Layout.fillWidth: true
                        }
                        Button {
                            text: qsTr("Full")
                            font.pixelSize: fontSizeExtraSmall
                            checkable: true

                            Layout.fillWidth: true
                        }
                    }

                    GlowingLabel {
                        id: glowingLabel
                        text: qsTr("Speed")
                        color: "white"
                        font.pixelSize: fontSizeMedium
                    }

                    Dial {
                        id: volumeDial
                        onValueChanged: dial_observer.speed = value.toFixed(0)
                        from: 0
                        value: 0
                        to: 250
                        stepSize: 1
                        Layout.alignment: Qt.AlignHCenter
                        Layout.minimumWidth: 64
                        Layout.minimumHeight: 64
                        Layout.preferredWidth: 128
                        Layout.preferredHeight: 128
                        Layout.maximumWidth: 128
                        Layout.maximumHeight: 128
                        Layout.fillHeight: true
                        Label {
                            horizontalAlignment: Text.AlignLeft
                            fontSizeMode: Text.FixedSize
                            color: "white"
                            text: volumeDial.value.toFixed(0)+"km/h"
                            font.pixelSize: Qt.application.font.pixelSize * 2
                            anchors.centerIn: parent
                        }


                    }


                    ButtonGroup {
                        id: audioSourceButtonGroup
                    }

                    RowLayout {
                        Layout.topMargin: 16


                        RadioButton {
                            id: radioButton
                            text: qsTr("Informatii Extra")
                            checked: false
                            display: AbstractButton.TextBesideIcon
                            anchors.fill: parent
                            transformOrigin: Item.Center
                            onClicked: { listFrame.visible = "visible"
                                dB.visible = "visible"
                            }
                        }

                    }

                }
            }

            Rectangle {
                color: colorMain
                implicitWidth: 1
                Layout.fillHeight: true
            }

            ColumnLayout {
                Layout.preferredWidth: 350
                Layout.fillWidth: true
                Layout.fillHeight: true

                GlowingLabel {
                    id: timeLabel
                    text: qsTr("11:02")
                    font.pixelSize: fontSizeExtraLarge

                    Layout.alignment: Qt.AlignHCenter


                }

                Connections{
                    target: timp
                    onTextChanged: timeLabel.text = timp.getSomething()

                }

                Label {
                    id: dataLabel
                    text: qsTr("01/01/2018")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    color: colorLightGrey
                    font.pixelSize: fontSizeMedium

                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 13
                }

                Connections{
                    target: dataT
                    onTextChanged: dataLabel.text = dataT.getSomething()

                }

                Image {
                    source: "qrc:/icons/car.png"
                    fillMode: Image.PreserveAspectFit

                    Layout.fillHeight: true

                    Column {
                        x: parent.width * 0.88
                        y: parent.height * 0.56
                        spacing: 3
                    }
                }

                Text {
                    objectName: "myLabel"
                    id: txt
                    width: 200
                    height: 29
                    color: "#faf9f9"
                    text: myGlobalObject.getSomething()
                    font.pixelSize: 12
                }
            }
            Rectangle {
                color: colorMain
                implicitWidth: 1
                Layout.fillHeight: true
            }

            ColumnLayout {
                Row {
                    spacing: 8

                    Image {
                        source: "qrc:/icons/weather.png"
                    }

                    Column {
                        spacing: 8

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter

                            GlowingLabel {
                                id: outsideTempValueLabel
                                text: qsTr("31")
                                font.pixelSize: fontSizeExtraLarge
                            }

                            Connections{
                                target: vreme
                                onTextChanged: outsideTempValueLabel.text = vreme.getSomething()
                            }

                            GlowingLabel {
                                text: qsTr("°C")
                                font.pixelSize: Qt.application.font.pixelSize * 2.5
                                anchors.baseline: outsideTempValueLabel.baseline
                            }
                        }

                        Row{
                            spacing: 1
                            Text {
                                id: countrycity
                                text: "Oras"
                                color: colorLightGrey
                                font.pixelSize: fontSizeMedium
                            }
                            Connections{
                                target: oras
                                onTextChanged: countrycity.text = oras.getSomething()

                            }
                            Text {

                                text: ","
                                color: colorLightGrey
                                font.pixelSize: fontSizeMedium
                            }



                            Text {
                                id: country
                                text: "Tara"
                                color: colorLightGrey
                                font.pixelSize: fontSizeMedium
                            }
                            Connections{
                                target: tara
                                onTextChanged: country.text = tara.getSomething()

                            }


                        }
                        Connections{
                            target: viteza
                            onTextChanged: speed.text = viteza.getSomething()
                        }




                        Image {
                            x: 0
                            width: 50
                            height: 50
                            fillMode: Image.Stretch
                            source: "qrc:/icons/sign.png"
                            TextField
                            {
                                Text {
                                    id: speed
                                    x: 13
                                    y: 12
                                    color: "#000000"
                                    text: "Viteza"
                                    font.bold: true
                                    anchors.alignWhenCentered: parent
                                    //anchors.centerIn: parent
                                    fontSizeMode: Text.Fit
                                    //leftPadding: 0
                                    // topPadding: 15
                                    font.pixelSize: fontSizeMedium
                                }
                            }

                        }


                    }
                }

                ColumnLayout {
                    id: airConRowLayout
                    spacing: 8

                    Layout.preferredWidth: 128
                    Layout.preferredHeight: 380
                    Layout.fillHeight: true



                    // QTBUG-63269

                    Text {
                        id: element
                        color: "#f3f2f2"
                        text: qsTr("Alerte:")
                        elide: Text.ElideNone
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignLeft
                        transformOrigin: Item.Center
                        Layout.fillHeight: false
                        Layout.fillWidth: false
                        font.pixelSize: 15
                    }


                    Text {
                        id: alerts
                        color: "#fa1111"
                        text: "Nicio alerta"
                        font.bold: false
                        fontSizeMode: Text.FixedSize
                        elide: Text.ElideNone
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignLeft
                        transformOrigin: Item.Center
                        Layout.fillHeight: false
                        font.pixelSize: 16
                    }


                    Item {
                        x: 5
                        Layout.fillHeight: true
                    }

                    SwitchDelegate {
                        text: qsTr("AC")
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0

                        Layout.fillWidth: true
                    }

                    Connections{
                        target: alrt
                        onTextChanged: alerts.text = alrt.getSomething()

                    }




                    SwitchDelegate {
                        text: qsTr("Dezaburire")
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0

                        Layout.fillWidth: true
                    }

                    Frame {
                        id: frame2
                        x: 2
                        y: 100
                        width: 138
                        height: 172
                        clip: true
                        visible: false



                                                ListView {
                                                    id: listAccidente
                                                    //anchors.rightMargin: 0
                                                    //anchors.leftMargin: -82

                                                    //clip: true
                                                    anchors.fill: parent
                                                    model:sqlmodelalerte
                                                    delegate: Text {
                                                        text:"Ora: "+model.ora + "\n" +"Oras: "+model.nume +"\n"+ "S-a raportat: "+model.tipul+"\n"+"Pe strada: "+model.strada+"\n"
                                                        color:"#faf8f8"
                                                    }
                                                }
                                                ScrollIndicator.vertical: ScrollIndicator {
                                                    parent: frame1
                                                    anchors.top: parent.top
                                                    anchors.right: parent.right
                                                    anchors.rightMargin: 1
                                                    anchors.bottom: parent.bottom
                                                }
                    }









                }
            }

            Container {
                id: rightTabBar

                currentIndex: 1

                Layout.fillHeight: true

                ButtonGroup {
                    buttons: rightTabBarContentLayout.children
                }

                contentItem: ColumnLayout {
                    id: rightTabBarContentLayout
                    spacing: 3

                    Repeater {
                        model: rightTabBar.contentModel
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                FeatureButton {
                    text: qsTr("Windows")
                    icon.name: "windows"

                    Layout.maximumHeight: navigationFeatureButton.height
                    Layout.fillHeight: true
                }
                FeatureButton {
                    text: qsTr("Air Con.")
                    icon.name: "air-con"
                    checked: true

                    Layout.maximumHeight: navigationFeatureButton.height
                    Layout.fillHeight: true
                }
                FeatureButton {
                    text: qsTr("Seats")
                    icon.name: "seats"

                    Layout.maximumHeight: navigationFeatureButton.height
                    Layout.fillHeight: true
                }
                FeatureButton {
                    text: qsTr("Statistics")
                    icon.name: "statistics"

                    Layout.maximumHeight: navigationFeatureButton.height
                    Layout.fillHeight: true
                }
            }

        }

        Text {
            id: dB
            visible: false
            x: 127
            y: 499
            color: "#faf8f8"
            text: database.getSomething()
            font.pixelSize: 12
        }

        Frame {
            id: stationFrame
            x: 24
            y: 307
            width: 258
            height: 186

            ListView {
                id: listFrame
                //anchors.leftMargin: -82
                visible: false
                clip: true
                anchors.fill: parent
                model:sqlmodel
                delegate: Text {
                    text: model.nume + "->\n" +model.informatii_evenimente +"\n"+ model.informatii_combustibil +"\n"+"Vremea "+model.informatii_vreme +"°C" +"\n"
                    color:"#faf8f8"
                }
            }
            ScrollIndicator.vertical: ScrollIndicator {
                parent: stationFrame
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: 1
                anchors.bottom: parent.bottom
            }


        }

        Frame {
            id: frame1
            x: 740
            y: 250
            width: 201
            height: 149
            clip: false




                                    ListView {
                                        id: listAccidente1
                                        x: 0
                                        y: 0
                                        height: 143
                                        clip: true
                                        anchors.rightMargin: 1
                                        anchors.bottomMargin: 0
                                        anchors.leftMargin: -1
                                        anchors.topMargin: 1
                                        anchors.fill: parent
                                        model:sqlmodelalerte
                                        delegate:
                                            Text {
                                            id: listaAcc
                                            text:"Ora: "+model.ora + "\n" +"Oras: "+model.nume +"\n"+ "S-a raportat: "+model.tipul+"\n"+"Pe strada: "+model.strada+"\n"
                                            color:"#faf8f8"

                                        }



                                    }



                                    ScrollIndicator.vertical: ScrollIndicator {
                                        parent: frame1
                                        anchors.top: parent.top
                                        anchors.right: parent.right
                                        anchors.rightMargin: 1
                                        anchors.bottom: parent.bottom
                                    }

        }
//        Button {
//            onPressed: {listAccidente1.model=sqlmodelalerte
//                        listaAcc.text="Ora: "+model.ora + "\n" +"Oras: "+model.nume +"\n"+ "S-a raportat: "+model.tipul+"\n"+"Pe strada: "+model.strada+"\n"
//                        }
//            id: button1
//            x: 808
//            y: 405
//            text: qsTr("Update")
//        }
        FeatureButton {
            id: featureButton
            x: 599
            y: 178
            width: 88
            height: 66
            text: "Accident"
            onReleased: accident.doSomething(text)

        }


        FeatureButton {
            id: featureButton1
            x: 599
            y: 247
            width: 88
            height: 66
            text: "Ambuteiaj"
            onReleased: accident.doSomething(text)

        }

        FeatureButton {
            id: featureButton2
            x: 599
            y: 317
            width: 88
            height: 66
            text: "Obstacol"
            onReleased: accident.doSomething(text)
        }







    }
}




/*##^##
Designer {
    D{i:31;invisible:true}D{i:30;invisible:true}D{i:47;anchors_height:100;anchors_width:100;anchors_x:0}
D{i:35;invisible:true}D{i:34;invisible:true}
}
##^##*/
