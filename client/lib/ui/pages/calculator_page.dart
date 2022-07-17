import 'dart:math';

import 'package:build_link/data/styles/colors.dart';
import 'package:build_link/data/styles/fonts.dart';
import 'package:build_link/data/styles/styles.dart';
import 'package:build_link/ui/widgets/space.dart';
import 'package:build_link/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

final NumberFormat priceFormater = NumberFormat.currency(
  locale: 'ru_RU',
  symbol: '₽',
  decimalDigits: 0,
);

class CalculatorPage extends StatefulWidget {
  final int? initialCost;

  const CalculatorPage({Key? key, required this.initialCost}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  var calculated = false;

  var usingBonus = false;
  var isButtonPressable = false;

  var discountController =
      MaskedTextController(mask: '000 000 000 000 000 000 000');
  var benefitController = TextEditingController();

  var costController =
      MaskedTextController(mask: '000 000 000 000 000 000 000');

  var firstContributionController =
      MaskedTextController(mask: '000 000 000 000 000 000 000');
  var discountTermController = TextEditingController();
  var percentsController = TextEditingController();

  @override
  void initState() {
    costController.addListener(checkButtonEnabled);
    firstContributionController.addListener(checkButtonEnabled);
    discountTermController.addListener(checkButtonEnabled);
    percentsController.addListener(checkButtonEnabled);
    super.initState();
  }

  void checkButtonEnabled() {
    setState(() {
      isButtonPressable = costController.text.replaceAll(' ', '').isNotEmpty &&
          double.tryParse(costController.text.replaceAll(' ', '')) != null &&
          firstContributionController.text.replaceAll(' ', '').isNotEmpty &&
          double.tryParse(
                  firstContributionController.text.replaceAll(' ', '')) !=
              null &&
          discountTermController.text.isNotEmpty &&
          int.tryParse(discountTermController.text) != null &&
          percentsController.text.isNotEmpty &&
          double.tryParse(percentsController.text) != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 32),
            height: 48,
            child: Row(
              children: [
                Text(
                  "Калькулятор",
                  style: AppTextStyles.titleLarge,
                ),
                Text(
                  " Кредита",
                  style: AppTextStyles.titleLarge
                      .copyWith(color: AppColors.accent),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Входные данные:",
                              style: AppTextStyles.titleMedium
                                  .copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                        const Space(space: 16),
                        CustomTextField(
                          controller: costController,
                          label: "Стоимость жилья:",
                          suffix: "₽",
                        ),
                        const Space(space: 8),
                        CustomTextField(
                          controller: firstContributionController,
                          label: "Первонач. взнос:",
                          suffix: "₽",
                        ),
                        const Space(space: 8),
                        CustomTextField(
                          controller: discountTermController,
                          label: "Срок кредита:",
                          suffix: "мес",
                        ),
                        const Space(space: 8),
                        CustomTextField(
                          controller: percentsController,
                          label: "Процентная ставка:",
                          suffix: "%",
                        ),
                        const Space(space: 16),
                        Row(
                          children: [
                            Text(
                              "Скидки и льготы:",
                              style: AppTextStyles.titleMedium.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Space(space: 16),
                        CustomTextField(
                          controller: discountController,
                          label: "Размер скидки:",
                          suffix: "₽",
                        ),
                        const Space(space: 8),
                        CustomTextField(
                          controller: benefitController,
                          label: "Льготная ставка:",
                          suffix: "%",
                        ),
                        const Space(space: 8),
                        TextButton(
                          style: AppButtonStyle.cardButton,
                          onPressed: () {
                            if (isButtonPressable) {
                              setState(() {
                                usingBonus = (benefitController
                                            .text.isNotEmpty &&
                                        double.tryParse(
                                                benefitController.text) !=
                                            null) ||
                                    (discountController.text
                                            .replaceAll(' ', '')
                                            .isNotEmpty &&
                                        double.tryParse(discountController.text
                                                .replaceAll(' ', '')) !=
                                            null);
                                calculated = calculateCredit();
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 48,
                            constraints:
                                const BoxConstraints(minWidth: double.infinity),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: isButtonPressable
                                  ? AppColors.text
                                  : AppColors.divider,
                              border: Border.all(
                                  color: AppColors.divider, width: 0),
                            ),
                            child: Text(
                              "Рассчитать",
                              style: AppTextStyles.label.copyWith(
                                fontSize: 16,
                                color: isButtonPressable
                                    ? AppColors.background
                                    : AppColors.textDisable,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Space(
                  space: 24,
                  orientation: Axis.horizontal,
                ),
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Результаты:",
                              style: AppTextStyles.titleMedium
                                  .copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<double> creditSum = [];
  List<double> mountPay = [];
  List<double> procentSum = [];
  List<double> procentAndCredit = [];

  bool calculateCredit() {
    procentAndCredit = [];
    procentSum = [];
    mountPay = [];
    creditSum = [];

    creditSum.add(
      double.parse(costController.text.replaceAll(' ', '')) -
          double.parse(firstContributionController.text.replaceAll(' ', '')),
    );
    mountPay.add(calculatePay(
        double.parse(costController.text.replaceAll(' ', '')),
        int.parse(discountTermController.text),
        double.parse(percentsController.text)));
    procentSum.add(
      roundDouble(
        mountPay[0] * int.parse(discountTermController.text) - creditSum[0],
        2,
      ),
    );
    procentAndCredit.add(procentSum[0] + creditSum[0]);

    if (usingBonus) {
      double discount = discountController.text
                  .replaceAll(' ', '')
                  .isNotEmpty &&
              double.tryParse(discountController.text.replaceAll(' ', '')) !=
                  null
          ? double.parse(discountController.text.replaceAll(' ', ''))
          : 0;
      double benefit = benefitController.text.isNotEmpty &&
              double.tryParse(benefitController.text) != null
          ? double.parse(benefitController.text)
          : -1;

      creditSum.add(double.parse(costController.text.replaceAll(' ', '')) -
          double.parse(firstContributionController.text.replaceAll(' ', '')) -
          discount);
      if (benefit != -1) {
        mountPay.add(calculatePay(
            double.parse(costController.text.replaceAll(' ', '')) - discount,
            int.parse(discountTermController.text),
            benefit));
      } else {
        mountPay.add(
          calculatePay(
            double.parse(costController.text.replaceAll(' ', '')) - discount,
            int.parse(discountTermController.text),
            double.parse(percentsController.text),
          ),
        );
      }
      procentSum.add(
        roundDouble(
          mountPay[1] * int.parse(discountTermController.text) - creditSum[1],
          2,
        ),
      );
      procentAndCredit.add(procentSum[1] + creditSum[1]);

      procentAndCredit
          .add(roundDouble(procentAndCredit[0] - procentAndCredit[1], 2));
      mountPay.add(roundDouble(mountPay[0] - mountPay[1], 2));
      procentSum.add(roundDouble(procentSum[0] - procentSum[1], 2));
      creditSum.add(roundDouble(creditSum[0] - creditSum[1], 2));
    }
    return true;
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double calculatePay(double credit, int mounts, double procent) {
    procent /= 100;
    procent /= 12;
    num tmp = pow((1 + procent), mounts);
    return roundDouble(credit * ((procent) * tmp) / (tmp - 1), 2);
  }
}
