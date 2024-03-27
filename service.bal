import ballerina/http;
import ballerina/log;
import ballerina/time;

const UN_EMPLOYED = "un-employed";
const SELF_EMPLOYED = "self-employed";
const PERMENET = "permenent";
const CONTRACT = "contract";
const PART_TIME = "part-time";

type EmployementStatus UN_EMPLOYED|SELF_EMPLOYED|PERMENET|CONTRACT|PART_TIME;

type CreditHistoryResponse record {|
    string ssn;
    CreditHistory creditHistory;
|};

type CreditHistory record {|
    int totalLoans;
    int currentLoans;
    int closedLoans;
    int paymentsOnTime;
    int latePayments;
    int defaults;
    decimal totalDebt;
    decimal monthlyDebt;
|};

type CreditScoreResponse record {|
    string ssn;
    int score;
|};

type LoanRequest record {|
    string loanId;
    decimal amount;
    int loanDuration;
    string pourpose;
    Customer customer;
|};

type Customer record {|
    string customerId;
    string firstName;
    string lastName;
    time:Date dob;
    string ssn;
    decimal income;
    EmployementStatus employementStatus;
    string address;
|};

service /api/v1 on new http:Listener(8080) {

    function init() {
        log:printInfo("Mock loan server started on port: 8080");
    }

    resource function get credit\-score(string ssn) returns CreditScoreResponse {
        log:printInfo(string `Start: Get credit score for ssn: ${ssn}`);
        CreditScoreResponse & readonly creditScoreResponse = creditScoreResponses.get(ssn);
        log:printInfo(string `End: Get credit score for ssn: ${ssn}`);
        return creditScoreResponse;
    }

    resource function get credit\-history(string ssn) returns CreditHistoryResponse {
        log:printInfo(string `START: Get credit history for ssn: ${ssn}`);
        CreditHistoryResponse creditHistoryResponse = creditHistoryResponses.get(ssn);
        log:printInfo(string `END: Get credit history for ssn: ${ssn}`);
        return creditHistoryResponse;
    }

    resource function get loan/request(string id) returns LoanRequest {
        log:printInfo(string `START: Get loan request for id: ${id}`);
        LoanRequest loanRequest = onlineLoanRequests.get(id);
        log:printInfo(string `END: Get loan request for id: ${id}`);
        return loanRequest;
    }
}

