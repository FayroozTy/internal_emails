import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import '../../repository/MemoServive.dart';
import 'Memo_state.dart';
import 'Memo_event.dart';


class MemoBloc extends Bloc<MemoEvent, MemoState> {
  late Response data;
  final MemoRepository MemoRepo;

  MemoBloc(this.MemoRepo) : super(MemoInitial()) {
    on<MemoEvent>((event, emit) async {
      if (event is SendData) {
        emit(MemoLoading());
        await Future.delayed(const Duration(seconds: 3), () async {
          data = await MemoRepo.getList(event.contact_Person_ID,event.folderTypeId);
          emit(MemoLoaded(data));
        });
      }
    });
  }
}