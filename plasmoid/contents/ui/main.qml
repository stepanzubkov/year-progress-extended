/***************************************************************************
 *   Copyright (C) 2017 by Giancarlo Fringuello <gcarlo.f [at] gmail [dot] com> *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    property real timeout: 60000
    property string currentText: ""
    property real currentPercent: 0
    readonly property date currentDateTime: dataSource.data.Local ? dataSource.data.Local.DateTime : new Date()
    readonly property string currentYear: currentDateTime.getFullYear()
    property date prevDateTime
    
    function isLeapYear(p_year) 
    {
        return new Date(p_year, 1, 29).getDate() === 29;
    }

    function calculatePercentage(p_first_day, p_second_day)
    {
        console.log("Calculating percentage: " + p_first_day.toDateString() + " : " + p_second_day.toDateString());
        var l_result = 0.0;

        var l_days_total = 365;
        if(isLeapYear(currentYear))
        {
            console.log("Year: " + currentYear + " is a leap year!")
            l_days_total = 366;
        }

        
        var l_diff = Math.abs(p_second_day.getTime() - p_first_day.getTime());
        var l_days_elapsed = Math.floor(l_diff / (1000 * 3600 * 24)); 

        console.log("Days since: " + p_first_day.toDateString() + " -> " + l_days_elapsed + " (total:" + l_days_total + ")");

        if(0 != l_days_elapsed)
        {
            if(l_days_elapsed <= l_days_total)
            {
                l_result = (l_days_elapsed/l_days_total) * 100;
            }
        }
        if(100 < l_result)
        {
            l_result = 100;
        }

        console.log(currentYear+ " is " +  l_result.toFixed(2) +  + "% complete");
        return l_result.toFixed(1);
    }

    function checkDate()
    {
        var l_today = new Date();        
        var l_first_day = new Date(currentYear, 0, 1);

        currentPercent = calculatePercentage(l_first_day, l_today);
        currentText = currentYear + " is " + currentPercent + "% complete";
    }
    
    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 60000
        intervalAlignment: PlasmaCore.Types.AlignToMinute
    }
    
    onCurrentDateTimeChanged:
    {   
        if(prevDateTime.getDay() != currentDateTime.getDay())
        {
            console.log("onCurrentDateTimeChanged " +  currentDateTime + ", day changed from " + prevDateTime.getDay() + " to " + currentDateTime.getDay())
            prevDateTime = currentDateTime
            checkDate();
        }
    }

    
    Plasmoid.fullRepresentation: ColumnLayout {
        anchors.fill: parent
        spacing: 0
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignCenter
            text: currentText
        }
        PlasmaComponents.ProgressBar {
            Layout.alignment: Qt.AlignCenter
            value: currentPercent
            maximumValue: 100
            minimumValue: 0
        }
    }
    Component.onCompleted:
    {
        prevDateTime = currentDateTime
        checkDate();
    }
}
