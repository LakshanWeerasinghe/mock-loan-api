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
        string lastThreeDigits = ssn.substring(7, 10);
        int|error paredInt = int:fromString(lastThreeDigits);
        if paredInt is int {
            log:printInfo(string `End: Get credit score for ssn: ${ssn}`);
            return {ssn, score: paredInt};
        }
        log:printInfo(string `End: Get credit score for ssn: ${ssn}`);
        return {ssn, score: 775};
    }

    resource function get credit\-history(string ssn) returns CreditHistoryResponse {
        log:printInfo(string `START: Get credit history for ssn: ${ssn}`);
        log:printInfo(string `END: Get credit history for ssn: ${ssn}`);
        return {
            ssn,
            creditHistory: generateMockCreditHistory(ssn)
        };
    }

    resource function get loan/request(string id) returns LoanRequest {
        log:printInfo(string `START: Get loan request for id: ${id}`);
        log:printInfo(string `END: Get loan request for id: ${id}`);
        return {
            loanDuration: 48,
            amount: 70000,
            pourpose: "SAMPLE",
            loanId: id,
            customer: {
                customerId: "LOAN_CUS" + id,
                firstName: "John",
                lastName: "Doe",
                dob: {month: 0, year: 0, day: 0},
                ssn: "456-78-9012",
                income: 160000,
                employementStatus: PERMENET,
                address: "Texas"
            }
        };
    }
}

function generateMockCreditHistory(string ssn) returns CreditHistory {
    return {
        defaults: 0,
        currentLoans: 2,
        paymentsOnTime: 40,
        latePayments: 0,
        totalDebt: 62000,
        totalLoans: 6,
        closedLoans: 4
    };
}

function getLoanRequest() returns LoanRequest {
    return {
        loanDuration: 0,
        amount: 0,
        pourpose: "",
        loanId: "",
        customer: {customerId: "", firstName: "", lastName: "", dob: {month: 0, year: 0, day: 0}, ssn: "", income: 0, employementStatus: PERMENET, address: ""}
    };
}
