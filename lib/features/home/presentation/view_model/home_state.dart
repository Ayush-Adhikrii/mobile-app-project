import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({required this.selectedIndex, required this.views});

  @override
  List<Object> get props => [selectedIndex];
}