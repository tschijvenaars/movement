import 'package:desktop/infastructure/repositories/dtos/location_map_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../infastructure/repositories/dtos/movement_dto.dart';
import '../calendar/color_pallet.dart';
import '../theme/icon_mapper.dart';

class MovementTile extends StatelessWidget {
  MovementTile(this.movementDto);

  final MovementDto movementDto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(left: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 4,
            color: ColorPallet.lightGrayishBlue,
            margin: const EdgeInsets.only(right: 10, left: 2),
          ),
          FaIconMapper.getFaIcon(movementDto.vehicle?.key),
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            margin: const EdgeInsets.only(
              left: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movementDto.vehicle?.name == null ? "Onbekend" : movementDto.vehicle!.name!, style: Theme.of(context).primaryTextTheme.headline1),
                Text('${DateFormat('Hm').format(movementDto.classifiedPeriod.startDate)} - ${DateFormat('Hm').format(movementDto.classifiedPeriod.endDate)}',
                    style: Theme.of(context).primaryTextTheme.bodyText1)
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          const SizedBox(width: 35),
        ],
      ),
    );
  }
}
