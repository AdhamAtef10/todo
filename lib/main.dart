import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/src/app_root.dart';
import 'bloc/bloc_observer/bloc_observer.dart';


void main() {
      BlocOverrides.runZoned(()
      {
        runApp( const AppRoot());
      },
      blocObserver: MyBlocObserver());
}
