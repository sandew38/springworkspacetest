
package com.spring.board;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.board.model.BoardVO;
import com.spring.board.model.CommentVO;
import com.spring.board.service.BoardService;
import com.spring.common.FileManager;
import com.spring.member.model.MemberVO;

import oracle.net.aso.b;

// ==== #31. 컨트롤러 선언 ====

@Controller
@Component
// XML에서 bean을 만드는 대신에
// 클래스명 앞에 @Component 어노테이션을 쓰면
// 해당 클래스는 bean으로 자동 등록된다.
// 그리고 bean의 id는 해당 클래스명이 된다. (첫 글자는 소문자)

public class BoardController {

// ==== #33. 의존객체 주입하기 (DI : Dependency Injection) ====
	
		@Autowired
		private BoardService service; 
		
// ==== #130. 파일 업로드 & 다운로드를 위한 FileManager 클래스 의존 객체 주입하기 		
		@Autowired
		private FileManager fileManager;
	
//		연습용 페이지 3개
		@RequestMapping(value="/test.action", method={RequestMethod.GET})
		
		public String test(HttpServletRequest req)
		{
		
			return "main/test.tiles";
//			└> /Board/src/main/webapp/WEB-INF/views/main/test.jsp 파일을 생성한다.
		}

		@RequestMapping(value="/exam.action", method={RequestMethod.GET})
				
		public String exam(HttpServletRequest req)
		{
		
			return "practice/exam.tiles2";
//			└> /Board/src/main/webapp/WEB-INF/views2/practice/exam.jsp 파일을 생성한다.
		}
	
		@RequestMapping(value="/sample.action", method={RequestMethod.GET})
		
		public String sample(HttpServletRequest req)
		{
		
			return "sample.notiles";
//			└> /Board/src/main/webapp/WEB-INF/viewsnotiles/sample.jsp 파일을 생성한다.
		}
			
		
// ==== 네이버 로그인 폼 페이지 요청 ====

		@RequestMapping(value="/naverlogin.action", method={RequestMethod.GET})
		
		public String naverlogin(HttpServletRequest req)
		{			
			
			return "login/naverlogin.tiles";
//					└> /Board/src/main/webapp/WEB-INF/viewsnotiles/login/naverlogin.jsp 파일을 생성한다.
			
		} // end of String naverlogin(HttpServletRequest req) ----
		
		
// ==== 네이버 로그인 폼 페이지 요청 ====

		@RequestMapping(value="/callback.action", method={RequestMethod.GET})
		
		public String callback(HttpServletRequest req)
		{			
			
			return "login/callback.tiles";
//							└> /Board/src/main/webapp/WEB-INF/viewsnotiles/login/callback.jsp 파일을 생성한다.
			
		} // end of String callback(HttpServletRequest req) ----
		
		
// ==== #40. 메인 페이지 요청. ====	
		
		@RequestMapping(value="/index.action", method={RequestMethod.GET})
		
		public String index(HttpServletRequest req)
		{
			List<String> imgfilenameList = service.getImgfilenameList(); 
//			이미지파일의 이름 리스트를 가져오는 메소드 생성
			
			req.setAttribute("imgfilenameList", imgfilenameList);
			
			
			return "main/index.tiles";
//			└> /Board/src/main/webapp/WEB-INF/views/main/index.jsp 파일을 생성한다.
			
		} // end of public String index(HttpServletRequest req) ----
		
// ==== #44. 로그인 폼 페이지 요청 ====

		@RequestMapping(value="/login.action", method={RequestMethod.GET})
		
		public String login(HttpServletRequest req)
		{			
			
			return "login/loginform.tiles";
//			└> /Board/src/main/webapp/WEB-INF/views/login/loginform.jsp 파일을 생성한다.
			
		} // end of public String index(HttpServletRequest req) ----


// ==== #45. 로그인 완료 요청 ====

		@RequestMapping(value="/loginEnd.action", method={RequestMethod.POST})
		
		public String loginEnd(HttpServletRequest req, MemberVO loginuser, HttpSession session)
		{			
			String userid = req.getParameter("userid");
			String pwd = req.getParameter("pwd");
			
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("userid", userid);
			map.put("pwd", pwd);
//		  	로그인을 하려면 아이디와 암호가 DB에 저장된 것과 일치해야 한다. 
//			서비스단에서 로그인 여부 결과를 int 타입(1 또는 0 또는 -1)으로 받아온다.
			
			int n = service.loginEnd(map);
			// 넘겨받은 n 값이 1이면 아이디와 암호 일치 => 로그인
			// 0 이면 아이디는 존재하지만 암호 불일치
			// -1 이면 존재하지 않는 아이디 이다.
			
			// 로그인 결과 (1 또는 0 또는 -1)를 request 영역에 저장시켜서 
			// view 단 페이지로 넘긴다.
			req.setAttribute("n", n);
						
			if(n == 1)
			{
				loginuser = service.getLoginMember(userid);
				session.setAttribute("loginuser", loginuser);				
				
				// 사용자가 로그인하지 않고 보고있던 페이지(url)가 있으면 (글쓰기, 글수정, 글삭제 등)
				// 로그인 완료 후 해당 url 로 보내준다. 
				String url = (String)session.getAttribute("url");
				
				req.setAttribute("url", url);
				
				
			} // end of if ----
			
			
			return "login/loginEnd.tiles";
//			└> /Board/src/main/webapp/WEB-INF/views/login/loginform.jsp 파일을 생성한다.
			
		} // end of public String index(HttpServletRequest req) ----
		
		
		// ==== #53. 로그아웃 완료 요청 ====

			@RequestMapping(value="/logout.action", method={RequestMethod.GET})
			
			public String logout(HttpServletRequest req, HttpSession session)
			{			
				session.invalidate();
				
				return "login/logout.tiles";
//					└> /Board/src/main/webapp/WEB-INF/views/login/logout.jsp 파일을 생성한다.
				
			} // end of public String logout(HttpServletRequest req) ----
		
			
		// ==== #54. 글쓰기 폼 페이지 요청 ====
			
			@RequestMapping(value="/add.action", method={RequestMethod.GET})
			
			public String requireLogin_add(HttpServletRequest req, HttpServletResponse res)
			{			
				
			// ==== #119. 답변글쓰기가 추가되었으므로 아래와 같이 한다. ====
	
				String fk_seq = req.getParameter("fk_seq");
				String groupno = req.getParameter("groupno");
				String depthno = req.getParameter("depthno");
				
				
				
				req.setAttribute("fk_seq", fk_seq );
				req.setAttribute("groupno", groupno );
				req.setAttribute("depthno", depthno);
				
				return "board/add.tiles2";
//					└> /Board/src/main/webapp/WEB-INF/views2/board/add.jsp 파일을 생성한다.
				
			} // end of public String add() ----

			
			
			// ==== #55. 글쓰기 완료 요청 ====
			
			@RequestMapping(value="/addEnd.action", method={RequestMethod.POST})
			
/*			public String addEnd(BoardVO boardvo, HttpServletRequest req)
			{			
		====	#134. 파일 첨부하기가 추가된 글쓰기이므로
						기존의 파라미터를 삭제하고 다시 작성한다. 
			*/
			
			// ==== #55. 글쓰기 완료 요청 ====
			public String addEnd(BoardVO boardvo, MultipartHttpServletRequest req, HttpSession session)
			{				
	//	====	#135. 사용자가 쓴 글에 파일이 첨부가 된 것인지 확인한다.
				
				if(!boardvo.getAttach().isEmpty())
				{	// 첨부 파일이 있는 경우 (attach가 비어있지 않다.)
					// DB에 정보를 insert하기 전 파일을 업로드 한다.
					
				/*
					1. 사용자가 보낸 파일을 WAS(톰캣서버)의 특정 폴더에 저장해주어야 한다.
						>>>>> 파일이 업로드되어질 특정 경로(폴더) 지정해주기.
				  							└>	WAS의 webapp/resources/files
				  							
			  		WAS의 webapp 의 절대 경로를 알아와야 한다. 
				 */
					String rootpath = session.getServletContext().getRealPath("/");
					String path = rootpath + "resources" + File.separator + "files";
															// └> "/"을 말한다.
					// path가 첨부 파일들이 저장될 WAS(톰캣서버)의 폴더가 된다. 
					
			//		System.out.println("★★★ path : " + path + " ★★★");
					
				
			//		2. 파일 첨부를 위한 변수의 설정 및 값을 초기화한 후 파일 올리기 
					String newFileName = "";
			//		WAS(톰캣) 디스크에 저장한 파일명이다. 
					
					byte[] bytes = null;
			//		첨부파일을 WAS(톰캣) 디스크에 저장할 때 사용한다.
					
					long filesize = 0;
			//		파일 크기를 읽어오기 위함이다.
					
					try 
					{
						// 첨부된 파일을 byte[] 타입으로 얻어온다.
						bytes = boardvo.getAttach().getBytes();	
						// getBytes는 첨부된 파일을 바이트 단위로 전부 읽어오는 것이다. 
						
						newFileName = fileManager.doFileUpload(bytes, boardvo.getAttach().getOriginalFilename(), path);
						// 파일을 업로드 해준다. 
						// boardvo.getAttach().getOriginalFilename()은 첨부된 파일의 실제 파일명을 알아오는 것이다. 
						
					//	System.out.println("★★★★★ newFileName : " + newFileName);
					//	★★★★★ newFileName : 2017060817135928081613685970.jpg	
						
					//	==== DB의 spring_tblBoard 테이블에 있는
					//			fileName 컬럼과 originalFilename 컬럼, fileSize 컬럼에 값을 입력해줄 수 있도록
					//			boardvo 값을 수정한다. 
						
						boardvo.setFileName(newFileName);
						// 톰캣(WAS)에 저장된 파일명 
						
						boardvo.setOrgFilename(boardvo.getAttach().getOriginalFilename());
						// 실제 파일명 
						
						filesize = boardvo.getAttach().getSize();
						// 첨부한 파일의 파일 크기를 얻어온다.
						
						boardvo.setFileSize(String.valueOf(filesize));
						// 첨부한 파일의 크기를 String 타입으로 변경하여 넣어준다.(저장)
						
					}
					catch (Exception e) 
					{
						
					}
					
					
				}// end of if ---- 첨부파일 있는 경우 끝.
		
				
	//			int n = service.add(boardvo);
	//	====	#136. 파일 첨부가 없는 경우와 파일 첨부가 있는 경우로 나누어 서비스 단으로 보내줘야 한다.
				
				int n = 0;
				
				if(boardvo.getAttach().isEmpty())
				{	// 첨부 파일이 없는 경우
					
					n = service.add(boardvo);
				}
				else
				{	// 파일 첨부가 있는 경우
					n = service.add_withFile(boardvo);					
				}
				req.setAttribute("n", n); 
				
				return "board/addEnd.tiles2";
//								└> /Board/src/main/webapp/WEB-INF/views2/board/addEnd.jsp 파일을 생성한다.
				
			} // end of public String addEnd() ----
			
			
			
			// ==== #59. 글목록 보기 페이지 요청 ====
			
			@RequestMapping(value="/list.action", method={RequestMethod.GET})
			
			public String list(HttpServletRequest req, HttpSession session)
			{
				
			// ==== #108. 페이징 처리하기 ====
			// url 주소창에 /list.action?pageNo=3 처럼 해주어야 한다.	
				String pageNo = req.getParameter("pageNo");
				
				int totalCount = 0;			// 총 게시물 건 수 				
				int sizePerPage = 5;		// 한 페이지 당 보여줄 게시물 갯수
				int currentShowPageNo = 1;	// 현재 보여주는 페이지 번호로써, 초기치는 1페이지이다.
				int	totalPage = 0;			// 총 페이지 수 (웹 브라우저 상에 보여줄 총 페이지 갯수) 
				
				int start = 0;				// 시작 행 번호
				int end = 0;				// 끝 행 번호
				
				int startPageNo = 0;		// 페이지 바에서 시작될 페이지 번호
			/*
			 	"페이지 바"란?
			 	
			 	이전 5 페이지	1	2	3	4	5	다음 5 페이지
			 	이전 5 페이지	6	7	8	9	10	다음 5 페이지
			 	
			 	여기서 1, 6 을 startPageNo라고 한다.
			 	
			 */	
				int loop = 0;				// startPageNo 값이 증가할 때마다 1씩 증가한다.
				int blocksize = 5;			// 페이지 바를 5개씩 보여준다. 
				
				
				if(pageNo == null)
				{	// 게시판 초기화면에는
					// req.getParameter("pageNo"); 값이 없으므로 
					// pageNo 는 null이 된다. 
					
					currentShowPageNo = 1;
					// 즉, 초기 화면은 /list.action?pageNo=1로 해준다.
					
				}
				else
				{
					currentShowPageNo = Integer.parseInt(pageNo);
					// get 방식으로 파라미터 pageNo에 넘어온 값을
					// 현재 보여주고자하는 페이지로 설정한다. 
					
				} // end of if else ----
				
			/*	==== **** 가져올 게시글의 범위를 구한다. (★공식★) **** =====
			
				currentShowPageNo		start			end 
			---------------------------------------------------------------
					1 page		==>		1				5
					2 page		==>		6				10
					3 page		==>		11				15
					4 page		==>		16				20
					5 page		==>		21				25
					6 page		==>		26				30
					7 page		==>		31				35
					8 page		==>		36				40
					   :
					   :
					   :
			*/
				
				start = ( ( currentShowPageNo - 1 ) * sizePerPage ) + 1;
				end = start + sizePerPage - 1;
				
				
			/*
			 ================ 검색어가 없는 경우 ====================	
				List<BoardVO> boardList = service.boardList();
			 ========================================================
			*/	
				
//	==== #104. 검색어가 포함되었으므로 먼저 위의 검색어가 없는 경우는 주석처리한다.
				
				String colname = req.getParameter("colname");
				String search = req.getParameter("search");
				
				HashMap<String,String> map = new HashMap<String, String>();
				
				map.put("colname", colname);
				map.put("search", search);
				
				
		//	==== #109. 페이징 처리를 위해 start, end를 map에 추가하여 DB로 보낸다. ====		
				
				map.put("start", String.valueOf(start));	// 키 값 start, HashMap 이 String 타입인데 키 값 start는 int 타입이기 때문에 오류가 난다.  
				map.put("end", String.valueOf(end));		// String 타입으로 바꿔주면 된다.
				
				
				List<BoardVO> boardList = service.boardList(map);
						
		// ==== #111. 페이징 작업의 계속 ( 페이지 바에 나타낼 총 페이지 갯수를 구한다. )
				
			/*
			 	검색 조건이 없을 때의 총 페이지 수와
			 	(colname, search 값이 null인 경우)
			 	
			 	검색 조건이 있을 때의 총 페이지 수를 구해야 한다.
			 	(colname, search 값이 있는 경우)
			 	
			 	총 페이지 수를 구하기 위해, 먼저 총 게시물 건 수를 구한다.
			 	총 게시물 건 수는 검색 조건이 있을 때와 없을 때로 나뉜다. 
			 
			 */
				
				totalCount = service.getTotalCount(map);
				
		// 		====== 페이지 바 작성을 위한 작업 ======
				totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
				
				String pagebar = "";
				pagebar += "<ul>";
			/*
			 	우리는 위에서 blocksize를 5로 해놓았으므로
			 	아래와 같은 페이지 바가 생성되도록 해야 한다.
			 	
			 	이전 5 페이지	1	2	3	4	5	다음 5 페이지
			 	이전 5 페이지	6	7	8	9	10	다음 5 페이지
			 	이전 5 페이지		11	12	13		다음 5 페이지
			 	
			 	페이지 번호는 1씩 증가하므로 페이지 번호를 증가시켜주는 반복 변수가 필요하다.  
			 	이것을 위에서 선언한 loop를 사용한다. 
			 	이 때 loop는 blocksize의 크기보다 크면 안된다. 
			 */
				loop = 1;
				
		//		**** ★공식★ 페이지 바의 시작 페이지 번호 (startPageNo)값 만들기 ****
				startPageNo = ( (currentShowPageNo - 1) / blocksize ) * blocksize + 1 ;
				
		/*		
				현재 우리는 blocksize 를 위에서 5로 설정했다.
		             
		        만약에  조회하고자 하는  currentShowPageNo 가 3페이지라면
		        	startPageNo = ( (3 - 1)/5)*5 + 1;  ==> 1
		       
		        만약에  조회하고자 하는  currentShowPageNo 가 5페이지라면
		        	startPageNo = ( (5 - 1)/5)*5 + 1;  ==> 1
		         
		        만약에  조회하고자 하는  currentShowPageNo 가 7페이지라면
		        	startPageNo = ( (7 - 1)/5)*5 + 1;  ==> 6   
		         
		        만약에  조회하고자 하는  currentShowPageNo 가 10페이지라면
		        	startPageNo = ( (10 - 1)/5)*5 + 1;  ==> 6 
		         
		        만약에  조회하고자 하는  currentShowPageNo 가 12페이지라면
		        	startPageNo = ( (12 - 1)/5)*5 + 1;  ==> 11                     	
				
		*/	
				
				
		//		***** 이전 5페이지 만들기 *****
				
				if(startPageNo == currentShowPageNo)
				{	// 첫 페이지인경우 
					
					// pagebar += String.format("&nbsp;&nbsp;[이전%d페이지]", blocksize);
					
					pagebar += "";
					// pagebar += String.format("&nbsp;&nbsp; 다음 5페이지 ", ???)
				}
				else
				{	// 첫 페이지가 아닌 경우 
					
					if(colname == null || search == null) {
		        		// 검색어가 없는 경우
		        		pagebar += String.format("&nbsp;&nbsp;<a href='/board/list.action?pageNo=%d'>[이전%d페이지]</a>&nbsp;&nbsp;", startPageNo-1, blocksize); // 처음 %d 에는 startPageNo값 , 두번째 %d 에는 페이지바에 나타낼 startPageNo값 이다.		
		        	}
		        	else{
		        		// 검색어가 있는 경우
		        	    pagebar += String.format("&nbsp;&nbsp;<a href='/board/list.action?pageNo=%d&colname=%s&search=%s'>[이전%d페이지]</a>&nbsp;&nbsp;", startPageNo-1, colname, search, blocksize); // 검색어 있는 경우        		
		        	}
				}
						
				
		//		***** 이전 5페이지와 다음 5페이지 사이에 들어가는 것
				while( !( loop > blocksize ) || ( startPageNo > totalPage) )
				{
					
					if (startPageNo == currentShowPageNo)
					{
						pagebar += String.format("&nbsp;&nbsp; <span style='color:gold; font-weight: bold; text-decoration : underline; '>%d</span> &nbsp;&nbsp;", startPageNo ); 
					}
					
					else 
					{
						if (colname == null || search == null)
						{	// 검색어가 없는 경우 
							
							pagebar += String.format("&nbsp;&nbsp;<a href='/board/list.action?pageNo=%d'>%d</a>&nbsp;&nbsp;", startPageNo, startPageNo); 
							// 처음 %d 에는 startPageNo값 , 두번째 %d 에는 페이지바에 나타낼 startPageNo값 이다.
						}
						
						else
						{	// 검색어가 있는 경우 
							
							pagebar += String.format("&nbsp;&nbsp;<a href='/board/list.action?pageNo=%d&colname=%s&search=%s'>%d</a>&nbsp;&nbsp;", startPageNo, colname, search, startPageNo);
						}
						
					}
					
					loop++;
					startPageNo++;
					
				} // end of while ----
			
				
				 // **** 다음5페이지 만들기 ****
		        if(startPageNo > totalPage) {
		        	// 마지막 페이지바에 도달한 경우
		        	pagebar += String.format("&nbsp;&nbsp;[다음%d페이지]", blocksize);
		        }
		        else {
		        	// 마지막 페이지바가 아닌 경우
		        	
		        	if(colname == null || search == null) {
		        		// 검색어가 없는 경우
		        		pagebar += String.format("&nbsp;&nbsp;<a href='/board/list.action?pageNo=%d'>[다음%d페이지]</a>&nbsp;&nbsp;", startPageNo, blocksize); // 처음 %d 에는 startPageNo값 , 두번째 %d 에는 페이지바에 나타낼 startPageNo값 이다.		
		        	}
		        	else{
		        		// 검색어가 있는 경우
		        	    pagebar += String.format("&nbsp;&nbsp;<a href='/board/list.action?pageNo=%d&colname=%s&search=%s'>[다음%d페이지]</a>&nbsp;&nbsp;", startPageNo, colname, search, blocksize); // 검색어 있는 경우        		
		        	}	
		        }
		        
		        
		        pagebar += "</ul>";
				
				
				
				req.setAttribute("pagebar", pagebar);
				
				req.setAttribute("colname", colname);
				req.setAttribute("search", search);
				
				req.setAttribute("boardList", boardList); 
				
/*				==== #68. 글 조회수 (readCount) 증가( DML문 )는
					반드시 해당 글 제목을 클릭했을 때에만 증가되어야한다.
					( 새로고침 시 X )
					
					이것을 하기 위해서 session을 사용한다.				*/
				
				session.setAttribute("readCountPermission", "yes");
/*
 				글 목록을 보여주는 list.action 페이지에 들어오면
 				세션에 readCountPermission 값을 yes로 해준다.			*/
				
				return "board/list.tiles2";
//								└> /Board/src/main/webapp/WEB-INF/views2/board/list.jsp 파일을 생성한다.
				
			} // end of public String addEnd() ----
			
			
			
// ==== #63. 선택한 글 한개를 보여주는 페이지 요청 ====
			
			@RequestMapping(value="/view.action", method={RequestMethod.GET})
			
			public String view(HttpServletRequest req, HttpSession session)
			{			
				String seq = req.getParameter("seq");
				
				BoardVO boardvo = null;
				
				
/*				==== #67. 글 조회수 (readCount) 증가( DML문 )는
						반드시 해당 글 제목을 클릭했을 때에만 증가되어야한다.
						( 새로고침 시 X )
*/
				
				/*
				 	글 내용에 엔터("\r\n")가 들어가있으면
				 	엔터를 <br>러 대체시켜서
				 	request 영역으로 넘긴다. 
				 */
				
				if(session.getAttribute("readCountPermission")!= null 
				&& "yes".equals(session.getAttribute("readCountPermission")) )
				{	
					boardvo = service.getView(seq);	
					// 조회수 1 증가 후 글 1개를 가져온다.
					
					session.setAttribute("readCountPermission", "no");				
					// 세션에 있는 readCountPermission 의 값을 yes에서 no로 바꿔준다.
				}
				else
				{	// 새로고침 시
					boardvo = service.getViewWithNoCount(seq);						
					// 조회수 증가 없이 한 개의 글을 읽어오는 것!
				}
				
				String content = boardvo.getContent();
				content = content.replaceAll("\r\n", "<br>");
				
				boardvo.setContent(content);
				
				req.setAttribute("boardvo", boardvo); 
				
				
//		==== #89. 댓글 내용 가져오기
				List<CommentVO> commentList = service.getCommentList(seq);
				
				req.setAttribute("commentList", commentList);
				
				return "board/view.tiles2";
//								└> /Board/src/main/webapp/WEB-INF/views2/board/view.jsp 파일을 생성한다.
				
			} // end of public String addEnd() ----
			
			
			
			// ==== #70. 글 수정 폼 페이지 요청 ====

			@RequestMapping(value="/edit.action", method={RequestMethod.GET})
			
			public String requireLogin_edit(HttpServletRequest req, HttpServletResponse res, HttpSession session)
			{	
				// 수정할 글 번호 가져오기
				String seq = req.getParameter("seq");
				
				// 수정할 글 전체 내용 가져오기
				BoardVO boardvo = service.getViewWithNoCount(seq);
				// 조회수 증가 없이 한 개의 글을 읽어오는 것!
					
				MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
				
				if(	!loginuser.getUserid().equalsIgnoreCase(boardvo.getUserid()))
				{// 글쓴이와 수정하려는 글의 글쓴이가 일치하지 않는 경우
					
					String result = "다른 사용자의 글은 수정할 수 없습니다.";
					String loc = "javascript:history.back()";
					
					req.setAttribute("result", result);
					req.setAttribute("loc", loc);
					
					return "msg.notiles";
//							└>	/Board/src/main/webapp/WEB-INF/viewsnotiles/msg.jsp
					
				}
								
				// 글쓴이와 수정하려는 글의 글쓴이가 일치하는 경우
					
					// 가져온 1개의 글을 request 영역에 저장하여 view 단으로 넘긴다. 
					req.setAttribute("boardvo", boardvo);
					
					return "board/edit.tiles2";
//									└> /Board/src/main/webapp/WEB-INF/views2/board/addEnd.jsp 파일을 생성한다.

				
				
				
			} // end of public String edit() ----


			// ==== #71. 글 수정 완료하기 ====
			
			@RequestMapping(value="/editEnd.action", method={RequestMethod.POST})
			
			public String editEnd(BoardVO boardvo, HttpServletRequest req)
			{			
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("seq", boardvo.getSeq());
				map.put("subject", boardvo.getSubject());
				map.put("content", boardvo.getContent());
				map.put("pw", boardvo.getPw() );
				
		/*		글 수정을 하려면 원본 글의 암호와
		 		수정 시 입력한 암호가 일치해야 한다. 	
		 		서비스 단에서 글 수정을 처리한 결과를 int 타입으로 가져온다.	*/
				
				int n = service.edit(map);
				// 넘겨받은 값이 1이면 update 성공
				// 0이면 update 실패! (글 암호 불일치)
				
				// n ( 글 수정 결과 ) 값을 request 영역에 저장시켜서 view 단으로 보낸다.
				// 그리고 변경된 글을 보여주기 위해 request 영역에 변경한 글 번호도 저장한다.
				req.setAttribute("n", n );
				req.setAttribute("seq", boardvo.getSeq());
				// 수정한 글의 seq도 넘긴다.
							
				return "board/editEnd.tiles2";
//								└> /Board/src/main/webapp/WEB-INF/views2/board/editEnd.jsp 파일을 생성한다.
				
			} // end of public String add() ----
			
			
			// ==== #76. 글 삭제하는 폼 요청하기 ====
			
			@RequestMapping(value="/del.action", method={RequestMethod.GET})
			
			public String requireLogin_del(HttpServletRequest req, HttpServletResponse res, HttpSession session)
			{	
				// 삭제할 글 번호 가져오기
				String seq = req.getParameter("seq");
				
				// 삭제할 글 전체 내용 가져오기
				BoardVO boardvo = service.getViewWithNoCount(seq);
				// 조회수 증가 없이 한 개의 글을 읽어오는 것!
				
				MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
				
				if(	!loginuser.getUserid().equalsIgnoreCase(boardvo.getUserid()))
				{// 로그인한 유저와 삭제하려는 글의 글쓴이가 일치하지 않는 경우
					
					String result = "다른 사용자의 글은 삭제할 수 없습니다.";
					String loc = "javascript:history.back()";
					
					req.setAttribute("result", result);
					req.setAttribute("loc", loc);
					
					return "msg.notiles";
//							└>	/Board/src/main/webapp/WEB-INF/viewsnotiles/msg.jsp
					
				}
								
				// 로그인한 유저와 삭제하려는 글의 글쓴이가 일치하는 경우
					
					// 가져온 1개의 글을 request 영역에 저장하여 view 단으로 넘긴다. 
					req.setAttribute("boardvo", boardvo);
					
					return "board/del.tiles2";
//									└> /Board/src/main/webapp/WEB-INF/views2/board/addEnd.jsp 파일을 생성한다.

				
										
				
			} // end of public String edit() ----
				
			
			
			// ==== #71. 글 삭제 완료하기 ====
			
			@RequestMapping(value="/delEnd.action", method={RequestMethod.POST})
			
			public String delEnd(BoardVO boardvo, HttpServletRequest req) throws Throwable
			{			
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("seq", boardvo.getSeq());
				map.put("pw", boardvo.getPw() );
								
				int n = service.del(map);
				// 넘겨받은 값이 1이면 update 성공
				// 0이면 update 실패! (글 암호 불일치)
				
				// n ( 글 삭제 결과 ) 값을 request 영역에 저장시켜서 view 단으로 보낸다.
				// 그리고 변경된 글을 보여주기 위해 request 영역에 변경한 글 번호도 저장한다.
				req.setAttribute("n", n );
				req.setAttribute("seq", boardvo.getSeq());
				// 수정한 글의 seq도 넘긴다.
							
				return "board/delEnd.tiles2";
//								└> /Board/src/main/webapp/WEB-INF/views2/board/delEnd.jsp 파일을 생성한다.
				
			} // end of public String delEnd() ----
			
			
			
			
//		==== #84. 댓글쓰기 ====
			
			@RequestMapping(value="/addComment.action", method={RequestMethod.POST})
			
			public String requireLogin_addComment(HttpServletRequest req, HttpServletResponse res, CommentVO cvo) throws Throwable
			{			
				
				int result = service.addComment(cvo);
				
				if(result != 0)
				{	// 원 게시물(spring_tblBoard 테이블)에 댓글의 갯수(1씩 증가) 증가가 모두 성공했다면
					
					req.setAttribute("result", "댓글 쓰기 완료!");				
					
				}
				else
				{	// 댓글쓰기 또는 댓글 갯수 증가가 실패한 경우
					req.setAttribute("result", "댓글 쓰기 실패!");
					
				}
				
				String parentSeq = cvo.getParentSeq();	// 원래의 게시물 번호

				req.setAttribute("seq", parentSeq);
				
				return "board/addCommentEnd.tiles2";
							// └> /Board/src/main/webapp/WEB-INF/views2/board/addCommentEnd.jsp 파일을 생성한다.
				
			} // end of String requireLogin_addComment() ----

			
			
//			==== #145. 첨부파일 다운로드 받기 ====
			
			@RequestMapping(value="/download.action", method={RequestMethod.GET})
			public String requireLogin_download(HttpServletRequest req, HttpServletResponse res, HttpSession session )
			{			
				String seq = req.getParameter("seq");
				// 첨부 파일이 있는 글 번호
				
				// 파일을 다운받기 위해서는 
				// DB에서 첨부 파일이 있는 글 번호의 fileName을 알아와야 한다.  
				
				BoardVO boardvo = service.getViewWithNoCount(seq);
				
				String fileName = boardvo.getFileName();
				// DISK에서 다운받아와야할 fileName이다.
				
				String orgFilename = boardvo.getOrgFilename();
				// getOrgFilenamedms은 예를 들어 "youjeen.jpg" 를 말한다. 
				
				//WAS의 webapp 의 절대 경로를 알아와야 한다. 
				String rootpath = session.getServletContext().getRealPath("/");
				String path = rootpath + "resources" + File.separator + "files";
														// └> "/"을 말한다.
				// path가 첨부 파일들이 저장될 WAS(톰캣서버)의 폴더가 된다. 
				
				
				// ==== 다운로드하기 ====
				boolean bool = false;
				
				bool = fileManager.doFileDownload(fileName, orgFilename, path, res);
				// 파일 다운로드에 성공하면 true를 반환하고,
				// 파일 다운로드에 실패하면 false를 반환한다.
				
				String result = "";
				
				if(!bool)
				{
					result = "파일 다운로드 실패!";
				}
				
				
				String loc = "view.action?seq="+seq;
				
				// http://localhost:9090/board/view.action?seq=59
				
				req.setAttribute("bool", bool);				
				
				req.setAttribute("result", result);
				req.setAttribute("loc", loc);
				
				return "msg.notiles";
				
			} // end of String download() ----

			
// ==== #148. Ajax로 검색어 입력시 자동글 완성하기 ③ ====
			
/*  ==> jackson JSON 라이브러리와 함께 @ResponseBoady 사용하여 JSON 파싱하기 === //
  
	    @ResponseBody란?
	    	메소드에 @ResponseBody Annotation이 되어 있으면 return 되는 값은 View 단을 통해서 출력되는 것이 아니라 
	     	HTTP Response Body에 바로 직접 쓰여지게 된다. 
		    그리고 jackson JSON 라이브러리를 사용할때 주의해야할 점은 
	        메소드의 리턴타입은 행이 1개 일경우 HashMap<K,V> 이거나 Map<K,V> 이고 
            행이 2개 이상일 경우 List<HashMap<K,V>> 이거나 List<Map<K,V>> 이어야 한다.
			행이 2개 이상일 경우  ArrayList<HashMap<K,V>> 이거나
		                              ArrayList<Map<K,V>> 이면 안된다.!!!
	     
	        이와같이 jackson JSON 라이브러리를 사용할때의 장점은 View 단이 필요없게 되므로 간단하게 작성하는 장점이 있다. 
	*/

			@RequestMapping(value="/wordSearchShow.action", method={RequestMethod.GET})
			@ResponseBody
			public List<HashMap<String, Object>> wordSearchShow(HttpServletRequest req)
			{			
				List<HashMap<String, Object>> returnmapList = new ArrayList<HashMap<String, Object>>();
				
				String colname = req.getParameter("colname");
				String search = req.getParameter("search");
				
				HashMap<String, String> map = new HashMap<String, String>();
				
				map.put("colname", colname);
				map.put("search", search);
				
				System.out.println("★★ colname : " + colname);
				System.out.println("★★ search : " + search);
				
				List<HashMap<String,String>> searchWordCompleteList =  service.searchWordCompleteList(map);

				if(searchWordCompleteList != null)
				{
					for (HashMap<String, String> datamap: searchWordCompleteList)
					{
						HashMap<String, Object> submap = new HashMap<String, Object>();
						submap.put("RESULTDATA", datamap.get("SEARCHDATA"));
						
						returnmapList.add(submap);
					}
					
				} // end of if ----
				
				return returnmapList;
				
				
			} // end of public String wordSearchShow() ----

			

}
