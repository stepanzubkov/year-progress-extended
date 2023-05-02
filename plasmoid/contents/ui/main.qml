/*******************************************************************************
 *   Copyright (C) 2017 by Giancarlo Fringuello <gcarlo.f [at] gmail [dot] com> *
 *   Copyright (C) 2023 by Stepan Zubkov <zubkovbackend@gmail.com>              *
 *                                                                              *
 *   This program is free software; you can redistribute it and/or modify       *
 *   it under the terms of the GNU General Public License as published by       *
 *   the Free Software Foundation; either version 2 of the License, or          *
 *   (at your option) any later version.                                        *
 *                                                                              *
 *   This program is distributed in the hope that it will be useful,            *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 *   GNU General Public License for more details.                               *
 *                                                                              *
 *   You should have received a copy of the GNU General Public License          *
 *   along with this program; if not, write to the                              *
 *   Free Software Foundation, Inc.,                                            *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .             *
 ******************************************************************************/

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

Item {
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground

    property real timeout: 3600 * 1000
    property string currentText: "-"
    property real currentPercent: 0.0
    readonly property date currentDateTime: dataSource.data.Local ? dataSource.data.Local.DateTime : new Date()
    readonly property string currentYear: currentDateTime.getFullYear()
    property date prevDateTime


    function isLeapYear(year) {
        return !(year % 100 ? year % 4 : year % 400);
    }

    function milliseconds_to_days(ms) {
        return Math.floor(ms/ (1000 * 3600 * 24));
    }

    function calculatePercentage(first_date, second_date)
    {
        console.log("Calculating percentage: " + first_date.toDateString() + " : " + second_date.toDateString());

        var days_in_year = 365;
        if(isLeapYear(currentYear))
        {
            console.log("Year: " + currentYear + " is a leap year!")
            days_in_year = 366;
        }

        var milliseconds_elapsed = Math.abs(second_date.getTime() - first_date.getTime());
        jar days_elapsed = milliseconds_to_days(milliseconds_elapsed);

        console.log("Days since: " + first_date.toDateString() + " -> " + days_elapsed + " (total:" + days_in_year + ")");

        var result_percentage = 0.0;
        if(days_elapsed <= days_in_year)
        {
            result_percentage = (days_elapsed/days_in_year) * 100;
        }

        console.log(currentYear + " is " + result_percentage.toFixed(2) +  + "% complete");
        return result_percentage.toFixed(1);
    }

    function checkDate()
    {
        var today = new Date();
        var first_day_of_year = new Date(currentYear, 0, 1);

        currentPercent = calculatePercentage(first_day_of_year, today);
        currentText = i18nc("%1 is current year, %2 is percentage", "%1 is %2\% complete", currentYear, currentPercent);
    }

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: timeout
        intervalAlignment: PlasmaCore.Types.AlignToHour
    }

    onCurrentDateTimeChanged:
    {
        if(prevDateTime.getDay() != currentDateTime.getDay())
        {
            console.log("onCurrentDateTimeChanged " +  currentDateTime + ", day changed from " + prevDateTime.getDay() + " to " + currentDateTime.getDay());
            prevDateTime = currentDateTime;
            checkDate();
        }
    }


    Plasmoid.fullRepresentation: ColumnLayout {
        anchors.fill: parent
        spacing: 0
        PlasmaComponents3.Label {
            id: percentageLabel 
            Layout.alignment: Qt.AlignCenter
            text: currentText
            font.pointSize: plasmoid.configuration.labelFontSize
        }
        PlasmaComponents3.ProgressBar {
            id: progressBar
            implicitWidth: 300
            Layout.alignment: Qt.AlignCenter
            value: currentPercent
            to: 100
            from: 0
        }
    }
    Component.onCompleted:
    {
        prevDateTime = currentDateTime
        checkDate();
    }
}
