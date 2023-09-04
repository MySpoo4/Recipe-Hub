import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hub/services/bloc/ingredients/search/search_event.dart';
import 'package:recipe_hub/services/bloc/ingredients/search/search_state.dart';
import 'package:recipe_hub/services/crud/crud_exceptions.dart';
import 'package:recipe_hub/services/crud/search_service.dart';
import 'package:recipe_hub/util/util.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final SearchService service;
  TextEditingController controller;
  final List<Ingredient> _list = [];
  final List<String> _searchHistory = [];

  List<Ingredient> get list => _list;
  String get query => controller.value.text;
  List<String> get searchHistory => _searchHistory;

  SearchBloc({required this.service, required this.controller})
      : super(const SearchStateInitial()) {
    on<SearchEventQuery>(
      (event, emit) async {
        try {
          final list =
              await service.getIngredients(text: controller.value.text);
          _list.clear();
          _list.addAll(list);
          emit(SearchStateList());
        } on CouldNotFindElement catch (e) {
          emit(SearchStateList(exception: e));
        }
      },
    );

    on<SearchEventUpdate>(
      (event, emit) {
        emit(SearchStateList());
      },
    );
  }
  Future<List<Ingredient>> searchQuery(String query) async {
    final list = await service.getIngredients(text: query);
    return list;
  }

  void addSearch(String text) {
    if (_searchHistory.isNotEmpty) {
      if (_searchHistory.last != text) {
        _searchHistory.insert(0, text);
      }
    } else {
      _searchHistory.insert(0, text);
    }
  }

  void changeText(String text) {
    controller.text = text;
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}
