class Guarantor{

   int id;
   int loanProposalId;
   int memberId;
   String name;
   String father;
   String relation;
   String dateOfBirth;
   String age;
   String address;

   Guarantor({
     this.id,
     this.loanProposalId,
     this.memberId,
     this.name,
     this.father,
     this.relation,
     this.dateOfBirth,
     this.age,
     this.address
    });

   Map<String,dynamic> toMap(){
     return {
       "id":id,
       "loan_proposal_id":loanProposalId,
       "member_id":memberId,
       "name": name,
       "father": father,
       "relation": relation,
       "date_of_birth": dateOfBirth,
       "age": age,
       "address": address
     };
   }
}