describe OFX do
  empty_ofx = <<EOS
OFXHEADER:100
DATA:OFXSGML
VERSION:103
SECURITY:NONE
ENCODING:USASCII
CHARSET:1252
COMPRESSION:NONE
OLDFILEUID:NONE
NEWFILEUID:NONE

<OFX><SIGNONMSGSRSV1><SONRS><STATUS><CODE>0</CODE><SEVERITY>INFO</SEVERITY></STATUS><DTSERVER>20140211000000</DTSERVER><LANGUAGE>ENG</LANGUAGE><FI><ORG/><FID/></FI><INTU.BID/></SONRS></SIGNONMSGSRSV1><BANKMSGSRSV1><STMTTRNRS><TRNUID>0</TRNUID><STATUS><CODE>0</CODE><SEVERITY>INFO</SEVERITY></STATUS><STMTRS><CURDEF>USD</CURDEF><BANKACCTFROM><BANKID/><ACCTID/><ACCTTYPE/></BANKACCTFROM><BANKTRANLIST/><LEDGERBAL/></STMTRS></STMTTRNRS></BANKMSGSRSV1></OFX>
EOS

  ofx_with_info = <<EOS
OFXHEADER:100
DATA:OFXSGML
VERSION:103
SECURITY:NONE
ENCODING:USASCII
CHARSET:1252
COMPRESSION:NONE
OLDFILEUID:NONE
NEWFILEUID:NONE

<OFX><SIGNONMSGSRSV1><SONRS><STATUS><CODE>0</CODE><SEVERITY>INFO</SEVERITY></STATUS><DTSERVER>20140211000000</DTSERVER><LANGUAGE>ENG</LANGUAGE><FI><ORG>Stripe</ORG><FID>0</FID></FI><INTU.BID>0</INTU.BID></SONRS></SIGNONMSGSRSV1><BANKMSGSRSV1><STMTTRNRS><TRNUID>0</TRNUID><STATUS><CODE>0</CODE><SEVERITY>INFO</SEVERITY></STATUS><STMTRS><CURDEF>USD</CURDEF><BANKACCTFROM><BANKID>123456789</BANKID><ACCTID>Test</ACCTID><ACCTTYPE>CHECKING</ACCTTYPE></BANKACCTFROM><BANKTRANLIST><DTSTART>20140101</DTSTART><DTEND>20140201</DTEND></BANKTRANLIST><LEDGERBAL><BALAMT>0.0</BALAMT><DTASOF>20140201</DTASOF></LEDGERBAL></STMTRS></STMTTRNRS></BANKMSGSRSV1></OFX>
EOS

  ofx_with_transaction = <<EOS
OFXHEADER:100
DATA:OFXSGML
VERSION:103
SECURITY:NONE
ENCODING:USASCII
CHARSET:1252
COMPRESSION:NONE
OLDFILEUID:NONE
NEWFILEUID:NONE

<OFX><SIGNONMSGSRSV1><SONRS><STATUS><CODE>0</CODE><SEVERITY>INFO</SEVERITY></STATUS><DTSERVER>20140211000000</DTSERVER><LANGUAGE>ENG</LANGUAGE><FI><ORG>Stripe</ORG><FID>0</FID></FI><INTU.BID>0</INTU.BID></SONRS></SIGNONMSGSRSV1><BANKMSGSRSV1><STMTTRNRS><TRNUID>0</TRNUID><STATUS><CODE>0</CODE><SEVERITY>INFO</SEVERITY></STATUS><STMTRS><CURDEF>USD</CURDEF><BANKACCTFROM><BANKID>123456789</BANKID><ACCTID>Test</ACCTID><ACCTTYPE>CHECKING</ACCTTYPE></BANKACCTFROM><BANKTRANLIST><DTSTART>20140101</DTSTART><DTEND>20140201</DTEND><STMTTRN><TRNTYPE>CREDIT</TRNTYPE><DTPOSTED>20140101</DTPOSTED><TRNAMT>+100.23</TRNAMT><FITID>Test</FITID><NAME>Name</NAME><MEMO>Memo memo</MEMO></STMTTRN></BANKTRANLIST><LEDGERBAL><BALAMT>0.0</BALAMT><DTASOF>20140201</DTASOF></LEDGERBAL></STMTRS></STMTTRNRS></BANKMSGSRSV1></OFX>
EOS

  it "should generate empty OFX files" do
    ofx_builder = OFX::Builder.new do |ofx|
      ofx.dtserver = Date.new(2014,2,11)
    end
    
    ofx = ofx_builder.to_ofx
    expect( ofx ).to eq(empty_ofx)
  end

  it "should generate OFX files with bank info but no transactions" do
    ofx_builder = OFX::Builder.new do |ofx|
      ofx.dtserver = Date.new(2014,2,11)
      ofx.fi_org = "Stripe"
      ofx.fi_fid = "0"
      ofx.bank_id = "123456789"
      ofx.acct_id = "Test"
      ofx.acct_type = "CHECKING"
      ofx.dtstart = Date.new(2014,1,1)
      ofx.dtend = Date.new(2014,2,1)
      ofx.bal_amt = 0
      ofx.dtasof = Date.new(2014,2,1)
    end

    ofx = ofx_builder.to_ofx
    expect( ofx ).to eq(ofx_with_info)
  end


  it "should generate OFX files with transactions" do
    ofx_builder = OFX::Builder.new do |ofx|
      ofx.dtserver = Date.new(2014,2,11)
      ofx.fi_org = "Stripe"
      ofx.fi_fid = "0"
      ofx.bank_id = "123456789"
      ofx.acct_id = "Test"
      ofx.acct_type = "CHECKING"
      ofx.dtstart = Date.new(2014,1,1)
      ofx.dtend = Date.new(2014,2,1)
      ofx.bal_amt = 0
      ofx.dtasof = Date.new(2014,2,1)
    end

    ofx_builder.transaction do |ofx_tr|
      ofx_tr.dtposted = Date.new(2014,1,1)
      ofx_tr.trnamt = "100.23"
      ofx_tr.fitid = "Test"
      ofx_tr.name = "Name"
      ofx_tr.memo = "Memo memo"
    end

    ofx = ofx_builder.to_ofx
    expect( ofx ).to eq(ofx_with_transaction)
  end
end
