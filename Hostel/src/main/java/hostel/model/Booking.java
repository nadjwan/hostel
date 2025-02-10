package hostel.model;

public class Booking {
	private int bid;
	private String bdate;
	private String cin;
	private String cout;
	private int pax;
	private double price;
	private String status;
	private int uid;
	private int hid;
	private String uname;
	private String hname;
	private String hadd;
	private String email;
	
	public Booking() {
	}

	public int getBid() {
		return bid;
	}

	public void setBid(int bid) {
		this.bid = bid;
	}

	public String getBdate() {
		return bdate;
	}

	public void setBdate(String bdate) {
		this.bdate = bdate;
	}

	public String getCin() {
		return cin;
	}

	public void setCin(String cin) {
		this.cin = cin;
	}

	public String getCout() {
		return cout;
	}

	public void setCout(String cout) {
		this.cout = cout;
	}

	public int getPax() {
		return pax;
	}

	public void setPax(int pax) {
		this.pax = pax;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getUid() {
		return uid;
	}

	public void setUid(int uid) {
		this.uid = uid;
	}

	public int getHid() {
		return hid;
	}

	public void setHid(int hid) {
		this.hid = hid;
	}

	public String getUname() {
		return uname;
	}

	public void setUname(String uname) {
		this.uname = uname;
	}

	public String getHname() {
		return hname;
	}

	public void setHname(String hname) {
		this.hname = hname;
	}

	public String getHadd() {
		return hadd;
	}

	public void setHadd(String hadd) {
		this.hadd = hadd;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
