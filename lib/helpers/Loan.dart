void Calculate(double total, int Duration, double intdue, double loandue,
    double principalLoan, double loanRepaid, double DurationOverLoanDue, double DurationOverIntDue,
    int InstallmentNo, double CumInterestPaid, double CumIntCharge, String calcMethod,
    double vLoanInstallment,  double vInterestInstallment, int vDOC,
    int OrgID, int summaryid, double vcumLoanDue, double vcumIntDue, double cumInterestPaid,
    double cumIntCharge, double durationOverLoanDue,
    double durationOverIntDue, int installmentNo, int duration, int doc,
    int orgId, double intDue,
    double loanDue
    )
{

  double vCumInterestCharge;
  double vCumInterestPaid;
  vCumInterestCharge = cumIntCharge;
  vCumInterestPaid = cumInterestPaid;

  double vInterestBalance = (vCumInterestCharge - vCumInterestPaid);

  vLoanInstallment = 0;
  vInterestInstallment = 0;

  double vPrincipalLoan = principalLoan;
  double vLoanRepaid = loanRepaid;
  double vLoan = durationOverLoanDue;
  double vInt = durationOverIntDue;
  double vLoanDueSCase = durationOverLoanDue;
  double vIntDueSCase = durationOverIntDue;
  double vTotalInstall = (vLoan + vInt);

  if (installmentNo > duration)
  {

    vLoan = durationOverLoanDue;
    vInt = durationOverIntDue;

    vLoanDueSCase = durationOverLoanDue;
    vIntDueSCase = durationOverIntDue;
    vTotalInstall = vLoan + vInt;

    if (total == 0)
    {
      vLoanInstallment = 0;
      vInterestInstallment = 0;
    }
    else
    {
      if (calcMethod == "D")
      {
        if ((vPrincipalLoan - vLoanRepaid) >= total)
        {
          vLoanInstallment = total;
        }
        if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
        {
          vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
        }
        if ((vPrincipalLoan - vLoanRepaid) == 0)
        {
          vLoanInstallment = 0;
        }

        if (vLoan == 0 && vInt > 0)
        {
          if (total >= vInterestBalance)
          {
            vLoanInstallment = (total - vInterestBalance);
          }
          if (total <= vInt)
          {
            vLoanInstallment = 0;
          }
        }

        if (doc == 0)
        {
          if (vLoan > 0)
          {
            vLoanInstallment = (vLoan * total) / vTotalInstall;
          }
          else {
            if ((vPrincipalLoan - vLoanRepaid) >= total)
            {
              vLoanInstallment = total;
            }
            if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
            {
              vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
            }
            if ((vPrincipalLoan - vLoanRepaid) == 0)
            {
              vLoanInstallment = 0;
            }
          }
        }
      }
      else if (calcMethod == "A" || calcMethod == "R" || calcMethod == "D" || calcMethod == "F" || calcMethod == "H" || calcMethod == "S")
      {
        if ((vPrincipalLoan - vLoanRepaid) >= total)
        {
          vLoanInstallment = total;
        }
        if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
        {
          vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
        }
        if ((vPrincipalLoan - vLoanRepaid) == 0)
        {
          vLoanInstallment = 0;
        }

        if (doc == 0)
        {
          if (vLoan > 0)
          {
            vLoanInstallment = (vLoan * total) / vTotalInstall;
          }
          else {
            if ((vPrincipalLoan - vLoanRepaid) >= total)
            {
              vLoanInstallment = total;
            }
            if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
            {
              vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
            }
            if ((vPrincipalLoan - vLoanRepaid) == 0)
            {
              vLoanInstallment = 0;
            }
            if (vLoan == 0 && vInt > 0)
            {
              if (total >= vInterestBalance)
              {
                vLoanInstallment = (total - vInterestBalance);
              }
              if (total <= vInt)
              {
                vLoanInstallment = 0;
              }
            }
            if (vLoan == 0 && vInt == 0)
            {
              if (total > vInterestBalance)
              {
                vLoanInstallment = (total - vInterestBalance);
              }
              if (total <= vInterestBalance)
              {
                vLoanInstallment = 0;
              }
            }

          }
        }

      }
      else if (calcMethod == "E")
      {
        if (total > vInt)
        {
          vLoanInstallment = (total - vInt);
        }
        if (total <= vInt)
        {
          vLoanInstallment = 0;
        }
      }
      else {

        ////////// For Loan And Int equal 0 ///////////////////////
        if (vLoanDueSCase == 0 && vIntDueSCase > 0)
        {
          if (total >= vInterestBalance)
          {
            vLoanInstallment = (total - vInterestBalance);
          }
          if (total <= vIntDueSCase)
          {
            vLoanInstallment = 0;
          }
        }
        else if (vLoanDueSCase == 0 && vIntDueSCase == 0)
        {
          if (total > vInterestBalance)
          {
            vLoanInstallment = (total - vInterestBalance);
          }
          if (total <= vInterestBalance)
          {
            vLoanInstallment = 0;
          }
        }
        else if (vLoan > 0 && vInt > 0)
        { ///// for General Calculation /////
          vLoanInstallment = (vLoan * total) / vTotalInstall;
        }
        else {
          vLoanInstallment = (vLoan * total) / vTotalInstall;
        }

      }
    }

    if (total == 0)
    {
      vInterestInstallment = 0;
    }
    else {
      // start from 190 line
      if (calcMethod == "D")
      {
        ///////////// For Loan And Int equal 0 //////////////////
        if ((vPrincipalLoan - vLoanRepaid) >= total)
        {
          vInterestInstallment = 0;
        }
        if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
        {
          vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
        }
        if ((vPrincipalLoan - vLoanRepaid) == 0)
        {
          vInterestInstallment = total;
        }

        if (vLoan == 0 && vInt > 0)
        { // line 210
          if (total >= vInterestBalance)
          {
            vInterestInstallment = (total - vInterestBalance);
          }
          if (total <= vInt)
          {
            vInterestInstallment = 0;
          }
        }

        if (doc == 0)
        {
          if (vTotalInstall > 0)
          {
            vInterestInstallment = (vInt * total) / vTotalInstall;
          }
          else {
            if ((vPrincipalLoan - vLoanRepaid) >= total)
            {
              vInterestInstallment = 0;
            }

            if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
            {
              vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
            }

            if ((vPrincipalLoan - vLoanRepaid) == 0)
            {
              vInterestInstallment = total;
            }

          }
        }
      }
      else if (calcMethod == "A" || calcMethod == "R" || calcMethod == "D" || calcMethod == "F" || calcMethod == "H" || calcMethod == "S")
      {
        if ((vPrincipalLoan - vLoanRepaid) >= total)
        {
          vInterestInstallment = 0;
        }

        if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
        {
          vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
        }
        if ((vPrincipalLoan - vLoanRepaid) == 0)
        {
          vInterestInstallment = total;
        }
        if (doc == 0)
        {
          if (vTotalInstall > 0)
          {
            vInterestInstallment = (vInt * total) / vTotalInstall;
          }
          else {
            if ((vPrincipalLoan - vLoanRepaid) >= total)
            {
              vInterestInstallment = 0;
            }

            if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
            {
              vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
            }

            if ((vPrincipalLoan - vLoanRepaid) == 0)
            {
              vInterestInstallment = total;
            }

            if (vLoan == 0 && vInt > 0)
            {
              if (total >= vInterestBalance)
              {
                vInterestInstallment = vInterestBalance;
              }
              if (total < vInterestBalance)
              {
                vInterestInstallment = total;
              }
              if (total <= vInt)
              {
                vInterestInstallment = total;
              }
            }
            if (vLoan == 0 && vInt == 0)
            {
              if (total > vInterestBalance)
              {
                vInterestInstallment = vInterestBalance;
              }
              if (total <= vInterestBalance)
              {
                vInterestInstallment = total;
              }
            }
          }
        }
      }
      else if (calcMethod == "E")
      {  // line 296
        if (total > vInt)
        {
          vInterestInstallment = vInt;
        }
        if (total <= vInt)
        {
          vInterestInstallment = total;
        }
      }
      else {
        /////////// For Loan And Int equal 0 ///////////////
        if (vLoanDueSCase == 0 && vIntDueSCase > 0)
        {
          if (total >= vInterestBalance)
          {
            vInterestInstallment = vInterestBalance;
          }
          if (total <= vIntDueSCase)
          {
            vInterestInstallment = total;
          }
        }
        else if (vLoanDueSCase == 0 && vIntDueSCase == 0)
        {
          if (total > vInterestBalance)
          {
            vInterestInstallment = vInterestBalance;
          }
          if (total <= vInterestBalance)
          {
            vInterestInstallment = total;
          }
        }
        else if (vLoan > 0 && vInt > 0)
        {
          vInterestInstallment = (vInt * total) / vTotalInstall;
        }
        ///////////////// For General Calculation ///////////////////
        else {
          vInterestInstallment = (vInt * total) / vTotalInstall;
        }

        if (doc == 0)
        {
          if (vTotalInstall > 0)
          {
            vInterestInstallment = (vInt * total) / vTotalInstall;
          }
        }

        if (vLoan == 0 && vInt > 0)
        {
          if (total >= vInterestBalance)
          {
            vInterestInstallment = vInterestBalance;
          }
          if (total <= vInterestBalance)
          {
            vInterestInstallment = total;
          }
        }
      }
    }

    double vLoanTotal = total;
    double vLoanBal;
    if (calcMethod != "A")
    { // line 345

      double vCheck = (vLoanRepaid + vLoanInstallment);
      if (vCheck > vPrincipalLoan)
      {
        vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
        vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
      }

      vLoanBal = (vPrincipalLoan + vInterestBalance - vLoanRepaid);
      double calIns = (vLoanRepaid + vLoan);

      if (vLoan >= vLoanBal)
      {
        vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
        vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
      }

    }
    else if (calcMethod == "A" || calcMethod == "R")
    {
      vLoanBal = vPrincipalLoan - vLoanRepaid;
      var calIns = vInterestBalance + vLoanBal;

      if (vLoan >= calIns)
      {
        if (calcMethod == "F")
        {
          vInterestInstallment = vInterestBalance;
        }
        else {
          vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
        }
      }
    }

    var vLoanBalance = vPrincipalLoan - vLoanRepaid;
    var vBal = vLoanBalance + vInterestBalance;

    if (vBal <= total)
    {

      if (vInterestBalance > 0)
      {

        if (calcMethod == "F")
        {
          vInterestInstallment = vInterestBalance;
        }
        else {
          vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
        }

      }
      else {
        if (total > vLoanBalance)
        {
          if (calcMethod == "F")
          {
            vInterestInstallment = vInterestBalance;
          }
          else {
            vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
          }
        }
        else {
          vInterestInstallment = 0;
          vLoanInstallment = total;
        }
      }
    }

    if ((vLoanInstallment + vInterestInstallment) > total)
    {
      vLoanInstallment = total - vInterestInstallment;
    }

    if (calcMethod == "F")
    { // line 428
      if (total > vLoanInstallment + vInterestInstallment)
      {
        vLoanInstallment = 0;
        vInterestInstallment = 0;
        total = 0;
      }
    }

  }
  else {
    vLoan = loanDue;
    vInt = intDue;
    vTotalInstall = vLoan + vInt;
    if (total == 0)
    {
      vLoanInstallment = 0;
      vInterestInstallment = 0;
    }
    else {
      if (calcMethod == "D")
      {

        ////////////// For Loan And Int equal 0 ////////////////
        if (vLoan == 0 && vInt > 0)
        {
          if (total > vInt)
          {
            vLoanInstallment = (total - vInt);
          }
          if (total <= vInt)
          {
            vLoanInstallment = 0;
          }
        }
        else if (vLoan == 0 && vInt == 0)
        {
          if (total > vInterestBalance)
          {
            vLoanInstallment = (total - vInterestBalance);
          }
          if (total <= vInterestBalance)
          {
            vLoanInstallment = 0;
          }
        }
        else { ////////////// For General Calculation ////////////////////////
          if (total < vLoan)
          {
            vLoanInstallment = (vLoan * total) / vTotalInstall;
          }
          else {
            vLoanInstallment = (vLoan * total) / vTotalInstall;
          }
        }

      }
      else if (calcMethod == "A" || calcMethod == "R" || calcMethod == "V" || calcMethod == "S")
      {
        //////////// For Loan And Int equal 0 //////////////////////////////
        if (vLoan == 0 && vInt > 0)
        {
          if (calcMethod == "S")
          {
            if (total > vInterestBalance)
            {
              vLoanInstallment = total - vInterestBalance;
            }
            else
            {
              vLoanInstallment = 0;
            }
          }
          else
          {
            if (total > vInt)
            {
              vLoanInstallment = (total - vInt);
            }
            if (total <= vInt)
            {
              vLoanInstallment = 0;
            }
          }

        }
        else if (vLoan == 0 && vInt == 0)
        {
          if (total > vInterestBalance)
          {
            vLoanInstallment = (total - vInterestBalance);
          }
          if (total <= vInterestBalance)
          {
            vLoanInstallment = 0;
          }
        }else { ///////////// For General Calculation /////////////////////
          if (calcMethod == "A" || calcMethod == "S")
          {
            if (vInterestBalance > vInt)
            {
              if (total > vInterestBalance)
              {
                vLoanInstallment = (total - vInterestBalance);
              }
              if (total <= vInterestBalance)
              {
                vLoanInstallment = 0;
              }
            }
            else {
              if (total > vInterestBalance)
              {
                if (vInterestBalance <= 0)
                {
                  vLoanInstallment = total - vInterestBalance;

                }
                else
                  vLoanInstallment = (total - vInterestBalance);
              }
              if (total <= vInt)
              {
                vLoanInstallment = 0;
              }
            }
            //if (total > vInterestBalance)
            //{
            //    vLoanInstallment = (total - vInt);
            //}
            //if (total <= vInt)
            //{
            //    vLoanInstallment = 0;
            //}

          }
          else if (calcMethod == "R" || calcMethod == "V")
          {
            if (total > (vLoan + vInt) && total - (vLoan + vInt) > vInterestBalance - vInt)
            {

              if (vInterestBalance > 0)
              {
                vLoanInstallment = (total - vInterestBalance);
              }
              else {
                vLoanInstallment = total;
              }

            }
            else {

              if (total < (vLoan + vInt))
              {
                if (total < vInt)
                {
                  vLoanInstallment = 0;
                }
                else {
                  vLoanInstallment = (total - vInt);
                }
              }
              else {
                vLoanInstallment = vLoan;
              }
            }
          }
        }
      }
      else if (calcMethod == "H")
      {
        if (vInterestBalance > vInt)
        {
          if (total > vInterestBalance)
          {
            vLoanInstallment = (total - vInterestBalance);
          }
          if (total <= vInterestBalance)
          {
            vLoanInstallment = 0;
          }
          // vLoanInstallment = (parseFloat(total) - parseFloat(vInterestBalance))
        }

        else {
          if (total > vInt)
          {
            if (vInterestBalance <= 0)
            {
              vLoanInstallment = total - vInterestBalance;

            }
            else
              vLoanInstallment = (total - vInt);
          }
          if (total <= vInt)
          {
            vLoanInstallment = 0;
          }
        }
      }
      else if (calcMethod == "E")
      {
        if (total > vInt)
        {
          vLoanInstallment = (total - vInt);
        }
        if (total <= vInt)
        {
          vLoanInstallment = 0;
        }
      }
      else {
        /////////////// For Loan and Int equal 0 /////////////////
        if (vLoan == 0 && vInt > 0)
        {
          if (total >= vInterestBalance)
          {
            vLoanInstallment = (total - vInterestBalance);
          }
          if (total <= vInt)
          {
            vLoanInstallment = 0;
          }
        }
        else if (vLoan == 0 && vInt == 0)
        {
          if (total > vInterestBalance)
          {
            vLoanInstallment = (total - vInterestBalance);
          }
          if (total <= vInterestBalance)
          {
            vLoanInstallment = 0;
          }
        }else { ///////////////// For General Calculation /////////////////
          vLoanInstallment = (vLoan * total) / vTotalInstall;
        }
      }
    }

    if (total == 0)
    {
      vInterestInstallment = 0;
    }
    else {
      if (calcMethod == "D")
      {
        //////////////// For Loan And Int equal 0 //////////////////
        if (vLoan == 0 && vInt > 0)
        {
          if (total > vInt)
          {
            vInterestInstallment = vInt;
          }
          if (total <= vInt)
          {
            vInterestInstallment = total;
          }
        }
        else if (vLoan == 0 && vInt == 0)
        {
          if (total > vInterestBalance)
          {
            vInterestInstallment = vInterestBalance;
          }
          if (total <= vInterestBalance)
          {
            vInterestInstallment = total;
          }
        }
        else { ///////////////////// For General Calculation ///////////////////
          if (total < vInt)
          {
            vInterestInstallment = (vInt * total) / vTotalInstall;
          }
          else {
            vInterestInstallment = (vInt * total) / vTotalInstall;
          }

        }
      }
      else if (calcMethod == "A" || calcMethod == "R" || calcMethod == "V" || calcMethod == "S")
      {
        ///////////////////// For Loan And Int equal 0 ////////////////////////
        if (vLoan == 0 && vInt > 0)
        {
          if (calcMethod == "S")
          {
            if (total > vInterestBalance)
            {
              vInterestInstallment = total - vLoanInstallment;
            }
            else
            {
              vInterestInstallment = total;
            }

          }
          else
          {
            if (total > vInt)
            {
              vInterestInstallment = vInt;
            }
            if (total <= vInt)
            {
              vInterestInstallment = total;
            }
          }
          //if (total > vInt)
          //{
          //    vInterestInstallment = vInt;
          //}
          //if (total <= vInt)
          //{
          //    vInterestInstallment = total;
          //}
        }
        else if (vLoan == 0 && vInt == 0)
        {
          if (total > vInterestBalance)
          {
            if (vInterestBalance <= 0)
            {
              vInterestInstallment = 0;
            }
            else
              vInterestInstallment = vInterestBalance;

            //vInterestInstallment = vInterestBalance;
          }
          if (total <= vInterestBalance)
          {
            vInterestInstallment = total;
          }
        }

        else if (calcMethod == "A" || calcMethod == "R" || calcMethod == "D" || calcMethod == "F" || calcMethod == "H" || calcMethod == "S")
        {
          if (calcMethod=="S")
          {
            if (total > vInterestBalance)
            {
              vInterestInstallment = total - vLoanInstallment;
            }
            else
            {
              vInterestInstallment = total;
            }
          }
          else
          {

            if ((vPrincipalLoan - vLoanRepaid) >= total)
            {
              vInterestInstallment = 0;
            }

            if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
            {
              vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
            }
            if ((vPrincipalLoan - vLoanRepaid) == 0)
            {
              vInterestInstallment = total;
            }
            if (doc == 0)
            {
              if (vTotalInstall > 0)
              {
                vInterestInstallment = (vInt * total) / vTotalInstall;
              }
              else {
                if ((vPrincipalLoan - vLoanRepaid) >= total)
                {
                  vInterestInstallment = 0;
                }

                if ((vPrincipalLoan - vLoanRepaid) > 0 && (vPrincipalLoan - vLoanRepaid) < total)
                {
                  vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
                }

                if ((vPrincipalLoan - vLoanRepaid) == 0)
                {
                  vInterestInstallment = total;
                }

                if (vLoan == 0 && vInt > 0)
                {
                  if (total >= vInterestBalance)
                  {
                    vInterestInstallment = vInterestBalance;
                  }
                  if (total < vInterestBalance)
                  {
                    vInterestInstallment = total;
                  }
                  if (total <= vInt)
                  {
                    vInterestInstallment = total;
                  }
                }
                if (vLoan == 0 && vInt == 0)
                {
                  if (total > vInterestBalance)
                  {
                    if (vInterestBalance <= 0)
                    {
                      vInterestInstallment = 0;
                    }
                    else
                      vInterestInstallment = vInterestBalance;
                  }
                  if (total <= vInterestBalance)
                  {
                    vInterestInstallment = total;
                  }
                }
                if (vInterestBalance >= vInt)
                {
                  if (total > vInterestBalance)
                  {
                    vInterestInstallment = vInterestBalance;
                  }
                  if (total <= vInterestBalance)
                  {
                    vInterestInstallment = total;
                  }
                }
                if (vInterestBalance < vInt)
                {
                  if (total <= vInterestBalance)
                  {
                    vInterestInstallment = total;
                  }
                  else
                    vInterestInstallment = vInterestBalance;
                }
              }
            }
          }

        }

        else { //////////////// For General Calculation //////////////////////////
          if (calcMethod == "A")
          {

            if (vInterestBalance > vInt)
            {

              if (total > vInterestBalance)
              {
                vInterestInstallment = vInterestBalance;
              }
              if (total <= vInterestBalance)
              {
                vInterestInstallment = total;
              }

            }
            else {

              if (total > vInt)
              {
                vInterestInstallment = vInt;
              }
              if (total <= vInt)
              {
                vInterestInstallment = total;
              }

            }

          }
          else if (calcMethod == "R" || calcMethod == "V")
          {

            if (total > (vLoan + vInt) && total - (vLoan + vInt) > (vInterestBalance - vInt))
            {

              if (vInterestBalance > 0)
              {
                vInterestInstallment = vInterestBalance;
              }
              else {
                vInterestInstallment = 0;
              }

            }
            else {

              if (total < (vLoan + vInt))
              {

                if (total < vInt)
                {
                  vInterestInstallment = total;
                }
                else {
                  vInterestInstallment = vInt;
                }
              }
              else {
                vInterestInstallment = (total - vLoan);

              }

            }
          }

        }
      }
      else if (calcMethod == "E")
      {
        if (total > vInt)
        {
          vInterestInstallment = vInt;
        }
        if (total <= vInt)
        {
          vInterestInstallment = total;
        }
      }
      else {

        ///////////// For Loan And Int equal 0 ////////////////////////

        if (vLoan == 0 && vInt > 0)
        {

          if (total >= vInterestBalance)
          {
            vInterestInstallment = vInterestBalance;
          }

          if (total < vInterestBalance)
          {
            vInterestInstallment = total;
          }

          if (total <= vInt)
          {
            vInterestInstallment = total;
          }

        }
        else if (vLoan == 0 && vInt == 0)
        {

          if (total > vInterestBalance)
          {
            vInterestInstallment = vInterestBalance;
          }
          if (total <= vInterestBalance)
          {
            vInterestInstallment = total;
          }

        }
        else {
          vInterestInstallment = (vInt * total) / vTotalInstall;
        }
      }
    }

    if (calcMethod != "A")
    {
      double vCheck = (vLoanRepaid + vLoanInstallment);
      if (vCheck > vPrincipalLoan)
      {
        if (calcMethod == "F")
        {
          vInterestInstallment = vInterestBalance;
        }
        else {
          vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
          vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
        }
      }

      double vLoanBal = (vPrincipalLoan + vInterestBalance - vLoanRepaid);
      double calIns = (vLoanRepaid + vLoan);
      if (vLoan >= vLoanBal)
      {
        if (calcMethod == "F")
        {
          vInterestInstallment = vInterestBalance;
          vLoanInstallment = (total - vInterestBalance);
        }
        else {
          vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
          vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
        }
      }
    }
    else if (calcMethod == "A" || calcMethod == "R" || calcMethod == "V")
    {
      double vLoan1 = total;
      double vLoanBal = vPrincipalLoan - vLoanRepaid;
      double calIns = (vLoanRepaid + vLoan);
      if (calIns >= vPrincipalLoan)
      {
        vLoanInstallment = (total - vInterestInstallment);
      }
    }

    double vLoanBalance = vPrincipalLoan - vLoanRepaid;
    double vBal = (vLoanBalance + vInterestBalance);

    if (vBal <= total)
    {

      if (vInterestBalance > 0)
      {
        if (calcMethod == "F")
        {
          vInterestInstallment = vInterestBalance;
          if ((total - vInterestBalance) >= (vPrincipalLoan - vLoanRepaid))
          {
            vLoanInstallment = (total - vInterestBalance);
          }
        }
        else {
          vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
          vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
        }
      }
      else {
        if (total > vLoanBalance)
        {
          if (calcMethod == "F")
          {
            vInterestInstallment = vInterestBalance;
          }
          else {
            vInterestInstallment = total - (vPrincipalLoan - vLoanRepaid);
            vLoanInstallment = (vPrincipalLoan - vLoanRepaid);
          }
        }
        else {
          vInterestInstallment = 0;
          vLoanInstallment = 0;
        }
      }
    }

    if ((vLoanInstallment + vInterestInstallment) > total)
    {
      vLoanInstallment = total - vInterestInstallment;
    }

    if (calcMethod == "A" || calcMethod == "H")
    {
      double vLoanPayable = (total - vInterestInstallment);
      if (vLoanPayable > vPrincipalLoan)
      {
        double netLoanPay = total - vInterestBalance;
        vLoanInstallment = netLoanPay;
        double intPay = total - netLoanPay;
        vInterestInstallment = intPay;
      }
      else {
        vLoanInstallment = vLoanPayable;
      }
    }

    if (calcMethod == "F")
    {
      if (vInterestInstallment > vInterestBalance)
      {
        vInterestInstallment = vInterestBalance;
        vLoanInstallment = total - vInterestBalance;
      }
    }

    if (calcMethod == "F")
    {
      if (total > (vInterestBalance + vPrincipalLoan - vLoanRepaid))
      {
        total = 0;
        vLoanInstallment = 0;
        vInterestInstallment = 0;
      }
    }

    if (orgId == 54)
    {
      double vBuroLoanBal = (vPrincipalLoan - vLoanRepaid);
      double vBuroIntBal = (vCumInterestCharge - vCumInterestPaid);
      double vBuroActualBal = (vBuroLoanBal + vBuroIntBal);

      double vTotalInstallBuro = 0;
      double exceptIstIns = 0;
      double instMod;
      double vCumLoanDueF;
      double vCumIntDueF;
      double vTotalCumDue;
      double vCumLoanDue = 0;
      double vCumIntDue = 0;

      if (vBuroActualBal == total)
      {
        vInterestInstallment = vBuroIntBal;
        vLoanInstallment = vBuroLoanBal;
      }
      else {
        if (installmentNo == 1 && vLoanRepaid == 0)
        {
          if (total < (vLoan + vInt))
          {
            vInterestInstallment = 0;
            vLoanInstallment = 0;
            //              print(723);
          }
          else {
            //              print(726);
            vTotalInstallBuro = durationOverLoanDue + durationOverIntDue;
            exceptIstIns = total - (vLoan + vInt);
            if (exceptIstIns == 0)
            {
              vInterestInstallment = vInt;
              vLoanInstallment = vLoan;
            }
            else {
              //                print(733);
              instMod = (exceptIstIns % vTotalInstallBuro);
              if (instMod == 0)
              {
                vLoanInstallment = (durationOverLoanDue * exceptIstIns) / vTotalInstallBuro + vLoan;
                vInterestInstallment = (durationOverIntDue * exceptIstIns) / vTotalInstallBuro + vInt;
              }
              else {
                vLoanInstallment = 0;
                vInterestInstallment = 0;
              }
            }
          }
        }
        else {
          if (total == vLoan + vInt)
          {
            vLoanInstallment = vLoan;
            vInterestInstallment = vInt;
            //              print(745);
          }
          else {
            //              print(747);
            vCumLoanDueF = vCumLoanDue - vLoanRepaid;
            vCumIntDueF = vCumIntDue - vCumInterestPaid;
            vTotalCumDue = vCumLoanDueF + vCumIntDueF;

            if (vTotalCumDue > 0 && vLoanRepaid == 0)
            {
              total = total - (vCumLoanDueF + vCumIntDueF);
            }


            vTotalInstallBuro = (durationOverLoanDue + durationOverIntDue);
            //  print("durOverLoanDue ${durationOverLoanDue} durIntDue  ${durationOverIntDue}  total ${total} vTotalInstallBuro ${vTotalInstallBuro}");
            instMod = (total % vTotalInstallBuro);


            if (instMod == 0 )
            {
              vLoanInstallment = (durationOverLoanDue * total) / vTotalInstallBuro;
              vInterestInstallment = (durationOverIntDue * total) / vTotalInstallBuro;
              int noOfinst = total ~/ vTotalInstallBuro; //Convert.ToInt16
              int buroTotal = ((noOfinst * vTotalInstallBuro)).toInt();
              if (vTotalCumDue > 0 && vLoanRepaid == 0)
              {
                vLoanInstallment = vLoan + vCumLoanDueF;
                vInterestInstallment = vInt + vCumIntDueF;
              }
              else {
                vLoanInstallment = (durationOverLoanDue * total) / vTotalInstallBuro;
                vInterestInstallment = (durationOverIntDue * total) / vTotalInstallBuro;
              }
            }
            else {
              vLoanInstallment = 0;
              vInterestInstallment = 0;
            }
          }
        }
      }
    }

  }
}