package com.spring.board.model;

import org.springframework.web.multipart.MultipartFile;

// 		#55. VO 생성하기
//      먼저, 오라클에서 tblBoard 테이블을 생성해야 한다.
public class BoardVO {

 	private String seq;         // 글번호
 	private String userid;      // 사용자ID
 	private String name;        // 글쓴이
 	private String subject;     // 글제목
 	private String content;     // 글내용  
 	private String pw;          // 글암호
 	private String readCount;   // 글조회수
 	private String regDate;     // 글쓴시간
 	private String status;      // 글삭제여부  1:사용가능한글,  0:삭제된글  
 	
/*	==== #94. spring_tblBoard 테이블에
	commentCount  컬럼을 추가했다.	 */
 	private String commentCount;
	
//	==== #116. 답변형 게시판을 위한 멤버변수 추가하기 
//		먼저 spring_tblBoard 테이블과 spring_tblComment 테이블을 삭제 후 재 생성한다. 
 	
 	private String groupno;	
 	/*	답변글쓰기에 있어서 그룹번호
	 	원글(부모글)과 답변글은 동일한 groupno 를 가진다. 
	 	답변글이 아닌 원글(부모글)인 경우 groupno 의 값은 groupno 컬럼의 최대값(max)+1 로 한다.  */

 	private String fk_seq;	
 	/*	fk_seq 컬럼은 절대로 foreign key가 아니다.
	    fk_seq 컬럼은 자신의 글(답변글)에 있어서 
	    원글(부모글)이 누구인지에 대한 정보값이다.
	    답변글쓰기에 있어서 답변글이라면 fk_seq 컬럼의 값은 
	    원글(부모글)의 seq 컬럼의 값을 가지게 되며,
	    답변글이 아닌 원글일 경우 0 을 가지도록 한다.	*/

 	private String depthno;	
 	/*	답변글쓰기에 있어서 답변글 이라면                                                
    	원글(부모글)의 depthno + 1 을 가지게 되며,
    	답변글이 아닌 원글일 경우 0 을 가지도록 한다.	*/

 	
/*	==== #131. 파일 첨부를 할 수 있도록 VO 수정하기 	
 				먼저, 오라클에서 spring_tblBoard 테이블에
 				( fileName, orgFilename, fileSize ) 3개의 컬럼을 추가해준다.	 */
 	
 	private String fileName;	
 	//	WAS(톰캣)에 저장될 파일명(20161121324325454354353333432.png)
 	
 	private String orgFilename;
 	//	진짜 파일명(강아지.png)   
 	//	사용자가 파일을 업로드 하거나 파일을 다운로드 할때 사용되어지는 파일명
 	
 	private String fileSize;
 	//	파일크기
 	
 	private MultipartFile attach;
 	//	실제 파일 ==> WAS(톰캣서버) 디스크에 저장된다.
 	//	오라클 데이터베이스 spring_tblBoard 테이블의 컬럼이 아니다.
 	
 	public BoardVO() { }
 	
 	public BoardVO(String seq, String userid, String name, String subject, String content, String pw, String readCount, String regDate,
			String status, String commentCount, String groupno, String fk_seq, String depthno, String fileName, String orgFilename, String fileSize) {
		this.seq = seq;
		this.userid = userid;
		this.name = name;
		this.subject = subject;
		this.content = content;
		this.pw = pw;
		this.readCount = readCount;
		this.regDate = regDate;
		this.status = status;
		this.commentCount = commentCount;
		
		this.groupno = groupno;
		this.fk_seq = fk_seq;
		this.depthno = depthno;
		
		this.fileName = fileName;
		this.orgFilename = orgFilename;
		this.fileSize = fileSize;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getReadCount() {
		return readCount;
	}

	public void setReadCount(String readCount) {
		this.readCount = readCount;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(String commentCount) {
		this.commentCount = commentCount;
	}

	public String getGroupno() {
		return groupno;
	}

	public void setGroupno(String groupno) {
		this.groupno = groupno;
	}

	public String getFk_seq() {
		return fk_seq;
	}

	public void setFk_seq(String fk_seq) {
		this.fk_seq = fk_seq;
	}

	public String getDepthno() {
		return depthno;
	}

	public void setDepthno(String depthno) {
		this.depthno = depthno;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getOrgFilename() {
		return orgFilename;
	}

	public void setOrgFilename(String orgFilename) {
		this.orgFilename = orgFilename;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public MultipartFile getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}


	
	
	
}
