import 'package:desktop/infastructure/repositories/dtos/location_map_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/stop_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../infastructure/repositories/dtos/movement_dto.dart';
import '../calendar/color_pallet.dart';
import '../theme/icon_mapper.dart';

class StopTile extends StatelessWidget {
  StopTile(this.stopDto);

  final StopDto stopDto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 4,
                color: ColorPallet.lightGrayishBlue,
                margin: const EdgeInsets.only(right: 10, left: 2),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Stack(children: <Widget>[
                        Container(
                          height: 80,
                          width: 80,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 10, right: 10, left: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorPallet.veryDarkGray, width: 2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: FaIconMapper.getFaIcon(stopDto.reason?.key),
                        ),
                      ]),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          margin: const EdgeInsets.only(left: 5, bottom: 15),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(stopDto.googleMapsData?.name == null ? "Onbekend" : stopDto.googleMapsData!.name!.split(',')[0],
                                style: Theme.of(context).primaryTextTheme.headline1),
                            Text(
                                '${DateFormat('Hm').format(stopDto.classifiedPeriod.startDate)} - ${DateFormat('Hm').format(stopDto.classifiedPeriod.endDate)}',
                                style: Theme.of(context).primaryTextTheme.bodyText1)
                          ])),
                      const SizedBox(width: 35),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
