import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';

class DriverWalletTab extends StatefulWidget {
  const DriverWalletTab({super.key});

  @override
  State<DriverWalletTab> createState() => _DriverWalletTabState();
}

class _DriverWalletTabState extends State<DriverWalletTab>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock wallet data
  double _currentBalance = 125000.0;
  List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'type': 'earning',
      'amount': 2500.0,
      'description': 'Ride from Kigali City Center to Airport',
      'date': '2024-01-15',
      'time': '14:30',
      'status': 'completed',
    },
    {
      'id': '2',
      'type': 'earning',
      'amount': 1800.0,
      'description': 'Ride from Kimisagara to Nyabugogo',
      'date': '2024-01-15',
      'time': '12:15',
      'status': 'completed',
    },
    {
      'id': '3',
      'type': 'withdrawal',
      'amount': -50000.0,
      'description': 'Bank transfer to account',
      'date': '2024-01-14',
      'time': '18:45',
      'status': 'completed',
    },
    {
      'id': '4',
      'type': 'earning',
      'amount': 3200.0,
      'description': 'Ride from Remera to Kacyiru',
      'date': '2024-01-14',
      'time': '16:20',
      'status': 'completed',
    },
    {
      'id': '5',
      'type': 'bonus',
      'amount': 5000.0,
      'description': 'Weekly bonus for top driver',
      'date': '2024-01-13',
      'time': '09:00',
      'status': 'completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConfig.mediumAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _withdrawFunds() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Withdraw Funds',
          style: AppTheme.titleMedium.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Available Balance: RWF ${_currentBalance.toStringAsFixed(0)}',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              'Enter amount to withdraw:',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            TextField(
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimaryColor,
              ),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textTertiaryColor,
                ),
                prefixText: 'RWF ',
                prefixStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  borderSide: BorderSide(color: AppTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  borderSide: BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                AppTheme.successSnackBar(message: 'Withdrawal request submitted!'),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: Text(
              'Withdraw',
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Wallet',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppTheme.textPrimaryColor),
            onPressed: () {
              // TODO: Navigate to transaction history
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.spacing24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.1),
                          AppTheme.primaryColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppTheme.spacing8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing12),
                            Text(
                              'Current Balance',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacing16),
                        Text(
                          'RWF ${_currentBalance.toStringAsFixed(0)}',
                          style: AppTheme.titleLarge.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        Text(
                          'Available for withdrawal',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacing24),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.arrow_upward,
                          title: 'Withdraw',
                          subtitle: 'Transfer to bank',
                          onTap: _withdrawFunds,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing16),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.history,
                          title: 'History',
                          subtitle: 'View transactions',
                          onTap: () {
                            // TODO: Navigate to detailed history
                          },
                          color: AppTheme.successColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacing32),

                  // Recent Transactions
                  Text(
                    'Recent Transactions',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),

                  ..._transactions.map((transaction) => _buildTransactionCard(transaction)).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              title,
              style: AppTheme.titleSmall.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              subtitle,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isPositive = transaction['amount'] > 0;
    final isEarning = transaction['type'] == 'earning';
    final isWithdrawal = transaction['type'] == 'withdrawal';
    final isBonus = transaction['type'] == 'bonus';

    IconData icon;
    Color color;
    String typeText;

    if (isEarning) {
      icon = Icons.directions_car;
      color = AppTheme.successColor;
      typeText = 'Ride Earning';
    } else if (isWithdrawal) {
      icon = Icons.arrow_upward;
      color = AppTheme.errorColor;
      typeText = 'Withdrawal';
    } else if (isBonus) {
      icon = Icons.card_giftcard;
      color = AppTheme.warningColor;
      typeText = 'Bonus';
    } else {
      icon = Icons.payment;
      color = AppTheme.primaryColor;
      typeText = 'Transaction';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  typeText,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction['date']} at ${transaction['time']}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textTertiaryColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : ''}RWF ${transaction['amount'].abs().toStringAsFixed(0)}',
                style: AppTheme.titleSmall.copyWith(
                  color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius6),
                ),
                child: Text(
                  transaction['status'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
