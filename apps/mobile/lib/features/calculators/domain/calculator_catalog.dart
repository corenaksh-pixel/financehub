import 'package:flutter/material.dart';

import 'calculator_info.dart';

import 'package:financehub/features/emi/presentation/emi_screen.dart';
import 'package:financehub/features/gst/presentation/gst_screen.dart';
import 'package:financehub/features/sip/presentation/sip_screen.dart';
import 'package:financehub/features/fd/presentation/fd_screen.dart';
import 'package:financehub/features/rd/presentation/rd_screen.dart';
import 'package:financehub/features/ppf/presentation/ppf_screen.dart';
import 'package:financehub/features/income_tax/presentation/income_tax_screen.dart';

class CalculatorCatalog {
  const CalculatorCatalog._();

  static const calculators = <CalculatorInfo>[
    CalculatorInfo(
      id: 'emi',
      title: 'EMI Calculator',
      subtitle: 'Loan EMI Calculator',
      icon: Icons.account_balance,
      category: CalculatorCategory.loans,
      popular: true,
      screen: EmiScreen(),
    ),

    CalculatorInfo(
      id: 'gst',
      title: 'GST Calculator',
      subtitle: 'GST Add & Remove',
      icon: Icons.receipt_long,
      category: CalculatorCategory.tax,
      popular: true,
      screen: GstScreen(),
    ),

    CalculatorInfo(
      id: 'sip',
      title: 'SIP Calculator',
      subtitle: 'Mutual Fund SIP',
      icon: Icons.trending_up,
      category: CalculatorCategory.investment,
      popular: true,
      screen: SipScreen(),
    ),

    CalculatorInfo(
      id: 'fd',
      title: 'Fixed Deposit',
      subtitle: 'FD Calculator',
      icon: Icons.savings,
      category: CalculatorCategory.savings,
      popular: true,
      screen: FdScreen(),
    ),

    CalculatorInfo(
      id: 'rd',
      title: 'Recurring Deposit',
      subtitle: 'RD Calculator',
      icon: Icons.account_balance_wallet,
      category: CalculatorCategory.savings,
      popular: false,
      screen: RdScreen(),
    ),

    CalculatorInfo(
      id: 'ppf',
      title: 'PPF Calculator',
      subtitle: 'Public Provident Fund',
      icon: Icons.security,
      category: CalculatorCategory.savings,
      popular: false,
      screen: PpfScreen(),
    ),

    CalculatorInfo(
      id: 'income_tax',
      title: 'Income Tax',
      subtitle: 'FY 2026-27',
      icon: Icons.payments,
      category: CalculatorCategory.tax,
      popular: true,
      screen: IncomeTaxScreen(),
    ),
  ];
  static List<CalculatorInfo> get popular =>
      calculators.where((c) => c.popular).toList();

  static List<CalculatorInfo> byCategory(CalculatorCategory category) =>
      calculators.where((c) => c.category == category).toList();

  static int get total => calculators.length;
}
