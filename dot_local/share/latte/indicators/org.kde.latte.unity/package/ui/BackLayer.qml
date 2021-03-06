/*
*  Copyright 2019  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
    Loader {
        anchors.fill: parent
        active: indicator.isTask || indicator.isSquare

        sourceComponent: Item {
            anchors.fill: parent

            Item{
                id: rectangleItem
                width: indicator.isTask || indicator.isSquare ? Math.min(parent.width, parent.height) : parent.width
                height: indicator.isTask || indicator.isSquare ? width : parent.height
                anchors.centerIn: parent

                property bool isActive: indicator.isActive || (indicator.isWindow && indicator.hasActive)
                readonly property int size: Math.min(parent.width, parent.height)

                Rectangle {
                    id: unityRect
                    anchors.fill: parent
                    visible: indicator.isActive
                             || (indicator.isWindow && indicator.hasShown)
                             || (indicator.isMinimized && indicator.configuration.colorsForMinimized)

                    radius: indicator.currentIconSize / 12
                    color: indicator.iconBackgroundColor
                    clip: true
                }

                RadialGradient{
                    id: glowGradient
                    anchors.verticalCenter: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - unityRect.anchors.margins * 2 - 1
                    height: (width * 0.85) - unityRect.anchors.margins * 2 - 1
                    visible: false

                    gradient: Gradient {
                        GradientStop { position: 0.0;
                            color: {
                                if (indicator.isMinimized && !indicator.configuration.colorsForMinimized) {
                                    return "#aafcfcfc";
                                }

                                return indicator.iconGlowColor;
                            }
                        }
                        GradientStop { position: 0.6; color: "transparent" }
                    }
                    //! States
                    states: [
                        State {
                            name: "top"
                            when: !indicator.configuration.glowReversed

                            AnchorChanges {
                                target: glowGradient
                                anchors{horizontalCenter:parent.horizontalCenter; verticalCenter:parent.top}
                            }
                        },
                        State {
                            name: "bottom"
                            when: indicator.configuration.glowReversed

                            AnchorChanges {
                                target: glowGradient
                                anchors{horizontalCenter:parent.horizontalCenter; verticalCenter:parent.bottom}
                            }
                        }
                    ]
                }

                Item {
                    id: gradientMask
                    anchors.fill: glowGradient

                    Rectangle {
                        id: glowMaskRect
                        width: glowGradient.width
                        height: glowGradient.height / 2
                        radius: unityRect.radius

                        //! States
                        states: [
                            State {
                                name: "top"
                                when: !indicator.configuration.glowReversed

                                AnchorChanges {
                                    target: glowMaskRect
                                    anchors{bottom: undefined; top: parent.verticalCenter;}
                                }
                                PropertyChanges{
                                    target: gradientMask
                                    anchors{bottomMargin: undefined; topMargin: unityRect.anchors.margins}
                                }
                            },
                            State {
                                name: "bottom"
                                when: indicator.configuration.glowReversed

                                AnchorChanges {
                                    target: glowMaskRect
                                    anchors{bottom: parent.verticalCenter; top: undefined;}
                                }
                                PropertyChanges{
                                    target: gradientMask
                                    anchors{bottomMargin: unityRect.anchors.margins; topMargin: undefined}
                                }
                            }
                        ]
                    }

                    visible: false
                }

                OpacityMask {
                    anchors.fill: glowGradient
                    source: glowGradient
                    maskSource: gradientMask
                    visible: unityRect.visible || borderRectangle.visible
                    opacity: indicator.configuration.glowOpacity
                }

                Rectangle {
                    id: borderRectangle
                    anchors.fill: parent
                    visible: (indicator.isTask && indicator.isWindow) || (indicator.isApplet && indicator.isActive)
                    color: "transparent"
                    border.width: 1
                    border.color: "#25303030"
                    radius: unityRect.radius
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: parent.border.width
                        radius: unityRect.radius
                        color: "transparent"
                        border.width: 1
                        border.color: "#25dedede"
                    }
                }
            }
        }
    }

    Loader {
        anchors.fill: parent
        active: !indicator.isSquare && indicator.isActive
        sourceComponent: Item{
            anchors.fill: parent

            Rectangle {
                id: lineRectangle
                color: theme.buttonFocusColor

                width: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? length : thickness
                height: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickness : length

                readonly property int length: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? parent.width : parent.height
                readonly property int thickness: Math.max(2, indicator.currentIconSize * 0.06)

                states: [
                    State {
                        name: "left"
                        when: (plasmoid.location === PlasmaCore.Types.LeftEdge)

                        AnchorChanges {
                            target: lineRectangle
                            anchors{ top:undefined; bottom:undefined; left:undefined; right:parent.right;
                                horizontalCenter: undefined; verticalCenter: parent.verticalCenter}
                        }
                    },
                    State {
                        name: "right"
                        when: (plasmoid.location === PlasmaCore.Types.RightEdge)

                        AnchorChanges {
                            target: lineRectangle
                            anchors{ top:undefined; bottom:undefined; left:parent.left; right:undefined;
                                horizontalCenter: undefined; verticalCenter: parent.verticalCenter}
                        }
                    },
                    State {
                        name: "bottom"
                        when: (plasmoid.location === PlasmaCore.Types.BottomEdge)

                        AnchorChanges {
                            target: lineRectangle
                            anchors{ top:parent.top; bottom:undefined; left:undefined; right:undefined;
                                horizontalCenter: parent.horizontalCenter; verticalCenter: undefined}
                        }
                    },
                    State {
                        name: "top"
                        when: (plasmoid.location === PlasmaCore.Types.TopEdge)

                        AnchorChanges {
                            target: lineRectangle
                            anchors{ top:undefined; bottom:parent.bottom; left:undefined; right:undefined;
                                horizontalCenter: parent.horizontalCenter; verticalCenter: undefined}
                        }
                    }
                ]
            }
        }
    }
}
