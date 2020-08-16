;Growtopia AutoFarm Ver 1.0 by LightJean
F9:: ;시작
CoordMode, Pixel, Client
CoordMode, Mouse, Client
global line_clear := false
global dc_check := false
global restart := false
global line_number := 1

Loop ;층마다 반복
{
	if(line_number = 27) ;모든 층을 다 돌고 맨 꼭대기 층에 도착했을 때
	{
		DropItem()
		MoveToNextWorld()
		line_number := 1
		continue
	}
	UseTractor()
	if(restart = true)
	{
		restart = false
		continue
	}
	MoveRight()
	if(restart = true)
	{
		restart = false
		continue
	}
	UnuseTractor()
	if(restart = true)
	{
		restart = false
		continue
	}
	Respawn()
	Loop ;현재 층의 모든 블럭을 다 주워서 부술 때까지 반복
	{
		if(line_clear = true)
		{
			line_clear := false
			break
		}
		MoveRight()
		if(restart = true)
		{
			restart = false
			continue
		}
		BlockSelectAndBreak()
		if(restart = true)
		{
			restart = false
			continue
		}
		Respawn()
	}
	MoveRightAndPlantSeed()
	if(restart = true)
	{
		restart = false
		continue
	}
	Respawn()
	Jump()
	line_number += 1
}
return
;매크로 끝

F10:: ;종료
ExitApp

CheckImage() ;이미지 인식 여부 반환 함수
{
	if(ErrorLevel = 0) ;이미지 인식 성공
	{
		return 1
	}
	else ;이미지 인식 실패
	{
		return 0
	}
}

CheckWhiteDoor() ;플레이어가 하얀문에 있는지 확인하는 함수
{
	ImageSearch, foundX, foundY, 546, 247, 874, 580, *50 %A_ScriptDir%\image\start_redblock.bmp ;월드 입구 확인
	if(CheckImage()) ;플레이어가 하얀 문에 있으면
	{
		Send, {d down} ;포탈 타기
		sleep, 300
		Send, {d up}
	}
}

WaitUntilQuitFromWhiteDoor() ;입구에서 나왔는지 확인하는 함수
{
	Loop
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY, 28, 226, 357, 560, *50 %A_ScriptDir%\image\start_redblock.bmp ;입구에서 나왔는지 확인
		if(CheckImage()) ;입구에서 나왔으면
		{
			break
		}
		sleep, 1000 ;1초 간격으로 반복
	}
}

UseTractor() ;트랙터 선택 및 착용 함수
{
	MouseClick, Left, 723, 762 ;인벤토리 열기
	sleep, 1000
	MouseClick, Left, 83, 812 ;옷 카테고리 클릭
	sleep, 1000
	ImageSearch, foundX, foundY, 602, 625, 728, 758, *50 %A_ScriptDir%\image\tractor_check.bmp ;트랙터가 이미 착용되었는지 확인(ex) 서버 튕김)
	if(CheckImage())
	{
		MouseClick, Left, 720, 416 ;인벤토리 닫기
		sleep, 1000
		return
	}
	MouseClick, Left, 670, 686 ;트랙터 선택
	sleep, 1000
	MouseClick, Left, 670, 686 ;트랙터 착용
	sleep, 1000
	Loop ;트랙터가 완전히 착용될 때까지 반복(서버 렉)
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY, 602, 625, 728, 758, *50 %A_ScriptDir%\image\tractor_check.bmp ;트랙터가 완전히 착용되었는지 확인
		if(CheckImage()) ;트랙터가 착용되었다면
		{
			break
		}
		sleep, 1000 ;1초 간격으로 반복
	}
	MouseClick, Left, 720, 416 ;인벤토리 닫기
	sleep, 1000
}

UnuseTractor() ;트랙터 선택 및 착용해제 함수
{
	MouseClick, Left, 723, 762 ;인벤토리 열기
	sleep, 1000
	MouseClick, Left, 83, 812 ;옷 카테고리 클릭
	sleep, 1000
	MouseClick, Left, 670, 686 ;트랙터 선택
	sleep, 1000
	MouseClick, Left, 670, 686 ;트랙터 착용해제
	sleep, 1000
	Loop ;트랙터가 완전히 착용해제 될 때까지 반복(서버 렉)
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY, 602, 625, 728, 758, *50 %A_ScriptDir%\image\tractor_uncheck.bmp ;트랙터가 완전히 착용해제 되었는지 확인
		if(CheckImage()) ;트랙터가 착용해제 되었다면
		{
			break
		}
		sleep, 1000 ;1초 간격으로 반복
	}
	MouseClick, Left, 720, 416 ;인벤토리 닫기
	sleep, 1000
}

MoveRight() ;빨간 블럭 나올때 까지 오른쪽으로 이동하는 함수
{
	Loop ;오른쪽 끝에 도착할 때까지 반복(서버 렉)
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY, 839, 216, 1198, 578, *50 %A_ScriptDir%\image\start_redblock.bmp ;오른쪽 끝에 도착했는지 확인
		Send, {d down} ;오른쪽 이동 버튼 누르기
		sleep, 500
		Send, {d up} ;오른쪽 이동 버튼 떼기
		if(CheckImage())
		{
			MouseClick, Left, 400, 387 ;왼쪽 쳐다보기
			sleep, 1000
			Send, {a down}
			sleep, 45
			Send, {a up}
			sleep, 1000
			break
		}
	}
}

Jump() ;점프 함수
{
	Send, {w down}
	sleep, 2000
	Send, {w up}
}

Respawn() ;리스폰 함수
{
	MouseClick, Left, 1373, 64 ;메뉴 클릭
	sleep, 2000
	MouseClick, Left, 724, 241 ;리스폰 클릭
	sleep, 5000
}

BlockSelectAndBreak() ;블럭 선택해서 제자리에서 설치 및 부수기 반복하는 함수
{
	MouseClick, Left, 723, 762 ;인벤토리 열기
	sleep, 1000
	MouseClick, Left, 85, 666 ;블럭 카테고리 선택
	sleep, 1000
	MouseClick, Left, 367, 596 ;검색창 클릭
	sleep, 1000
	Send, {f} ;농사 블럭 검색
	sleep, 300
	Send, {i}
	sleep, 300
	Send, {s}
	sleep, 300
	Send, {h}
	sleep, 300
	MouseClick, Left, 373, 690 ;농사 블럭 선택
	sleep, 2000
	ImageSearch, foundX, foundY, 263, 588, 461, 771, *80 %A_ScriptDir%\image\farmable_check.bmp ;현재 층에 있는 모든 블럭을 다 주워서 부쉈는지 확인
	if(CheckImage() = 0) ;모든 블럭을 다 주워서 부쉈다면
	{
		MouseClick, Left, 89, 594 ;검색창 누른거 취소(안하면 이후에 움직일 때 씹힘)
		sleep, 500
		MouseClick, Left, 720, 416 ;인벤토리 닫기
		sleep, 2000
		line_clear := true
		return
	}
	Loop
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY,  263, 588, 461, 771, *80 %A_ScriptDir%\image\farmable_check.bmp ;농사 블럭 다 썼는지 확인
		if(CheckImage() = 0) ;모든 블럭을 다 썼다면
		{
			MouseClick, Left, 89, 594 ;검색창 누른거 취소(안하면 이후에 움직일 때 씹힘)
			sleep, 500
			MouseClick, Left, 720, 416 ;인벤토리 닫기
			sleep, 1000
			break
		}
		MouseClick, Left, 737, 235 ;블럭 설치
		sleep, 100
		MouseClick, Left, 172, 690 ;주먹 선택
		sleep, 100
		MouseClick, Left, 737, 235 ,,,D ;펀치 버튼 누르기
		sleep, 1000
		MouseClick, Left, 737, 235 ,,,U ;펀치 버튼 떼기
		sleep, 100
		MouseClick, Left, 373, 690 ;농사 블럭 선택
		sleep, 100
	}
}

MoveRightAndPlantSeed() ;오른쪽으로 이동하면서 씨앗 심기
{
	MouseClick, Left, 723, 762 ;인벤토리 열기
	sleep, 1000
	MouseClick, Left, 80, 733 ;씨앗 카테고리 선택
	sleep, 1000
	MouseClick, Left, 367, 596 ;검색창 클릭
	sleep, 1000
	Send, {f} ;농사 씨앗 검색
	sleep, 300
	Send, {i}
	sleep, 300
	Send, {s}
	sleep, 300
	Send, {h}
	sleep, 300
	MouseClick, Left, 373, 690 ;농사 씨앗 선택
	sleep, 2000
	MouseClick, Left, 89, 594 ;검색창 누른거 취소(안하면 이후에 움직일 때 씹힘)
	sleep, 500
	Loop
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY, 837, 47, 1193, 405, *50 %A_ScriptDir%\image\start_redblock.bmp ;오른쪽 끝에 도착했는지 확인
		MouseClick, Left, 749, 238,,,D ;씨앗 심기
		Send, {d down} ;오른쪽 이동 버튼 누르기
		sleep, 5000
		MouseClick, Left, 749, 238,,,U ;씨앗 심기
		Send, {d up} ;오른쪽 이동 버튼 떼기
		sleep, 50
		if(CheckImage())
		{
			MouseClick, Left, 172, 690 ;주먹 선택
			sleep, 1000
			MouseClick, Left, 720, 416 ;인벤토리 닫기
			sleep, 1000
			MouseClick, Left, 400, 387 ;왼쪽 쳐다보기
			sleep, 1000
			Send, {a down} ;왼쪽으로 살짝 이동
			sleep, 45
			Send, {a up}
			sleep, 1000
			break
		}
	}
}

DropItem() ;남은 씨앗 및 에센스 같은 잡템 버리는 함수
{
	MouseClick, Left, 400, 387 ;왼쪽 쳐다보기
	sleep, 2000
	MouseClick, Left, 723, 762 ;인벤토리 열기
	sleep, 2000
	MouseClick, Left, 85, 666 ;블럭 카테고리 선택
	sleep, 2000
	Loop
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY, 296, 607, 443, 759, *50 %A_ScriptDir%\image\drop_finish.bmp ;아이템 다 버렸는지 확인
		if(CheckImage()) ;아이템을 다 버렸다면
		{
			break
		}
		MouseClick, Left, 369, 694 ;버릴 아이템 선택
		sleep, 2000
		MouseClick, Left, 1308, 798 ;버리기 버튼 누르기
		sleep, 5000
		Send, {Enter} ;버리기
		sleep, 5000
	}
	MouseClick, Left, 80, 733 ;씨앗 카테고리 선택
	sleep, 2000
	Loop
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY, 296, 607, 443, 759, *50 %A_ScriptDir%\image\drop_finish.bmp ;아이템 다 버렸는지 확인
		if(CheckImage()) ;아이템을 다 버렸다면
		{
			break
		}
		MouseClick, Left, 369, 694 ;버릴 아이템 선택
		sleep, 2000
		MouseClick, Left, 1308, 798 ;버리기 버튼 누르기
		sleep, 5000
		Send, {Enter} ;버리기
		sleep, 5000
	}
	MouseClick, Left, 87, 874 ;기타 카테고리 선택
	sleep, 1000
	Loop
	{
		Disconnected()
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		ImageSearch, foundX, foundY, 296, 607, 443, 759, *50 %A_ScriptDir%\image\drop_finish.bmp ;아이템 다 버렸는지 확인
		if(CheckImage()) ;아이템을 다 버렸다면
		{
			break
		}
		MouseClick, Left, 369, 694 ;버릴 아이템 선택
		sleep, 2000
		MouseClick, Left, 1308, 798 ;버리기 버튼 누르기
		sleep, 5000
		Send, {Enter} ;버리기
		sleep, 5000
	}
	MouseClick, Left, 89, 594 ;검색창 누른거 취소(안하면 이후에 움직일 때 씹힘)
	sleep, 2000
	MouseClick, Left, 720, 416 ;인벤토리 닫기
	sleep, 2000
}

Disconnected() ;현재 화면이 농사중인 화면인지 아닌지 확인하는 함수
{
	ImageSearch, foundX, foundY, 680, 2, 764, 51, *50 %A_ScriptDir%\image\disconnected.bmp ;농사중인 화면
	if(CheckImage() = 0) ;서버가 튕겼다면
	{
		dc_check := true
	}
	else ;서버가 안 튕겼다면
	{
		return ;무시
	}
}

Reconnect() ;서버 재접속하는 함수
{
	sleep, 30000 ;재접 전 30초 정도 기다리기
	ImageSearch, foundX, foundY, 64, 665, 498, 883, *50 %A_ScriptDir%\image\disconnected_check.bmp ;서버 접속 대기 화면인지 확인
	if(CheckImage() = 0)
	{
		ImageSearch, foundX, foundY, 1285, 6, 1409, 100, *50 %A_ScriptDir%\image\news_close_button.bmp ;뉴스창이 뜬 채로 자동 재접 되었는지 확인
		if(CheckImage())
		{
			Send, {Esc} ;뉴스 창 닫기
			sleep, 2000
			ImageSearch, foundX, foundY, 748, 694, 1367, 883, *50 %A_ScriptDir%\image\world_select.bmp ;월드 선택 화면인지 확인
			if(CheckImage())
			{
				MouseClick, Left, 1055, 790 ;Enter World 클릭
				sleep, 10000
				Loop
				{
					if(dc_check = true)
					{
						Reconnect()
						dc_check = false
						LocationRecovery()
						return ;다시 처음부터 하기 위해 현재 함수는 종료
					}
					ImageSearch, foundX, foundY, 643, 362, 782, 469, *50 %A_ScriptDir%\image\inven_opened.bmp ;인벤토리 열림 확인
					if(CheckImage())
					{
						MouseClick, Left, 720, 416 ;인벤토리 닫기
						sleep, 2000
						break
					}
					sleep, 1000
				}
				Loop
				{
					if(dc_check = true)
					{
						Reconnect()
						dc_check = false
						LocationRecovery()
						return ;다시 처음부터 하기 위해 현재 함수는 종료
					}
					ImageSearch, foundX, foundY, 546, 247, 874, 580, *50 %A_ScriptDir%\image\start_redblock.bmp ;월드 입구 확인
					if(CheckImage())
					{
						break
					}
					sleep, 1000
				}
			}
			else
			{
				Respawn()
				sleep, 4000
				MouseClick, Left, 720, 416 ;인벤토리 닫기
				sleep, 2000
			}
		}
		else ;뉴스창 안뜨고 바로 재접 된 경우
		{
			ImageSearch, foundX, foundY, 748, 694, 1367, 883, *50 %A_ScriptDir%\image\world_select.bmp ;월드 선택 화면인지 확인
			if(CheckImage())
			{
				MouseClick, Left, 1055, 790 ;Enter World 클릭
				sleep, 10000
				Loop
				{
					if(dc_check = true)
					{
						Reconnect()
						dc_check = false
						LocationRecovery()
						return ;다시 처음부터 하기 위해 현재 함수는 종료
					}
					ImageSearch, foundX, foundY, 643, 362, 782, 469, *50 %A_ScriptDir%\image\inven_opened.bmp ;인벤토리 열림 확인
					if(CheckImage())
					{
						MouseClick, Left, 720, 416 ;인벤토리 닫기
						sleep, 2000
						break
					}
					sleep, 1000
				}
				Loop
				{
					if(dc_check = true)
					{
						Reconnect()
						dc_check = false
						LocationRecovery()
						return ;다시 처음부터 하기 위해 현재 함수는 종료
					}
					ImageSearch, foundX, foundY, 546, 247, 874, 580, *50 %A_ScriptDir%\image\start_redblock.bmp ;월드 입구 확인
					if(CheckImage())
					{
						break
					}
					sleep, 1000
				}
			}
			else
			{
				Respawn()
				sleep, 4000
				MouseClick, Left, 720, 416 ;인벤토리 닫기
				sleep, 2000
			}
		}
	}
	else ;재접중 화면에서 멈춘 경우
	{
		Send, {Esc} ;로그인 창으로 이동
		sleep, 2000
		Loop
		{
			Loop ;로그인 창으로 정상적으로 이동했는지 1초마다 확인
			{
				ImageSearch, foundX, foundY, 771, 693, 1257, 879, *50 %A_ScriptDir%\image\login_check.bmp
				if(CheckImage())
				{
					break
				}
				sleep, 1000
			}
			MouseClick, Left, 1013, 800 ;Connect 버튼 누르기
			sleep, 30000 ;30초 대기
			ImageSearch, foundX, foundY, 1285, 6, 1409, 100, *50 %A_ScriptDir%\image\news_close_button.bmp ;월드 들어왔는지 확인
			if(CheckImage()) ;월드 들어왔으면
			{
				Send, {Esc} ;뉴스 창 닫기
				sleep, 2000
				MouseClick, Left, 720, 416 ;인벤토리 닫기
				sleep, 2000
				break
			}
			else
			{
				Send, {Esc} ;Cancel 누르기
				sleep, 2000
			}
		}
	}
}

LocationRecovery() ;원래 튕긴 곳으로 다시 돌아가는 함수
{
	CheckWhiteDoor()
	WaitUntilQuitFromWhiteDoor()
	MoveRight()
	Respawn()
	cnt := 0
	Loop ;서버 튕겼을 때 위치로 이동
	{
		if(dc_check = true)
		{
			Reconnect()
			dc_check = false
			LocationRecovery()
			return ;다시 처음부터 하기 위해 현재 함수는 종료
		}
		if(cnt = line_number - 1)
		{
			break
		}
		Jump()
		cnt += 1
	}
	restart := true ;농사를 처음부터 다시 해야함을 표시
}

MoveToNextWorld() ;다음 농사 월드로 이동하는 함수
{
	Send, {d down}
	sleep, 1000
	Send, {d up}
	WaitUntilQuitFromWhiteDoor()
}