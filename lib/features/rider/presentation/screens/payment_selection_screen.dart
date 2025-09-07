import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/config/app_config.dart';
import '../../../../shared/widgets/primary_button.dart';

class PaymentSelectionScreen extends ConsumerStatefulWidget {
  final String departure;
  final String destination;
  final String rideType;
  final String driverName;
  final String carModel;
  final String plateNumber;
  final int totalPrice;
  
  const PaymentSelectionScreen({
    super.key,
    required this.departure,
    required this.destination,
    required this.rideType,
    required this.driverName,
    required this.carModel,
    required this.plateNumber,
    required this.totalPrice,
  });

  @override
  ConsumerState<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends ConsumerState<PaymentSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedPaymentMethod = '';
  bool _isLoading = false;

  // Payment methods data
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'wallet',
      'name': 'KivuRide Wallet',
      'description': 'Pay from your wallet balance',
      'icon': Icons.account_balance_wallet,
      'color': AppTheme.primaryColor,
      'balance': 15000,
      'available': true,
    },
    {
      'id': 'mobile_money',
      'name': 'Mobile Money',
      'description': 'MTN, Airtel, or Tigo Mobile Money',
      'icon': Icons.phone_android,
      'color': AppTheme.infoColor,
      'balance': null,
      'available': true,
    },
    {
      'id': 'cash',
      'name': 'Cash',
      'description': 'Pay directly to the driver',
      'icon': Icons.money,
      'color': AppTheme.successColor,
      'balance': null,
      'available': true,
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'description': 'Visa, Mastercard, or local cards',
      'icon': Icons.credit_card,
      'color': AppTheme.warningColor,
      'balance': null,
      'available': true,
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
      begin: const Offset(0, 0.3),
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

  void _selectPaymentMethod(String paymentId) {
    setState(() {
      _selectedPaymentMethod = paymentId;
    });
  }

  void _confirmPayment() {
    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppTheme.errorSnackBar(message: 'Please select a payment method'),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar(message: 'Ride confirmed! Driver is on the way.'),
        );
        // Navigate back to home or to ride tracking
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> paymentMethod) {
    final isSelected = _selectedPaymentMethod == paymentMethod['id'];
    final hasBalance = paymentMethod['balance'] != null;
    final balance = paymentMethod['balance'] as int?;
    final isInsufficient = hasBalance && balance != null && balance < widget.totalPrice;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: InkWell(
        onTap: () => _selectPaymentMethod(paymentMethod['id']),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: isSelected 
                ? paymentMethod['color'].withOpacity(0.1)
                : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
            border: Border.all(
              color: isSelected 
                  ? paymentMethod['color']
                  : isInsufficient
                      ? AppTheme.errorColor.withOpacity(0.3)
                      : AppTheme.borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Payment method icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: paymentMethod['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
                child: Icon(
                  paymentMethod['icon'],
                  color: paymentMethod['color'],
                  size: 24,
                ),
              ),
              
              const SizedBox(width: AppTheme.spacing12),
              
              // Payment method details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            paymentMethod['name'],
                            style: AppTheme.titleSmall.copyWith(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: paymentMethod['color'],
                            size: 20,
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacing4),
                    
                    Text(
                      paymentMethod['description'],
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    
                    if (hasBalance) ...[
                      const SizedBox(height: AppTheme.spacing8),
                      Row(
                        children: [
                          Text(
                            'Balance: ',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          Text(
                            '${balance} RWF',
                            style: AppTheme.bodySmall.copyWith(
                              color: isInsufficient 
                                  ? AppTheme.errorColor 
                                  : AppTheme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isInsufficient) ...[
                            const SizedBox(width: AppTheme.spacing8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing6,
                                vertical: AppTheme.spacing2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.errorColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.borderRadius6),
                              ),
                              child: Text(
                                'Insufficient',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.errorColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
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
          'Payment',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Ride summary
                Container(
                  margin: const EdgeInsets.all(AppTheme.spacing12),
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ride Summary',
                        style: AppTheme.titleMedium.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spacing12),
                      
                      // Route
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing12),
                          Expanded(
                            child: Text(
                              widget.departure,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacing8),
                      
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing12),
                          Expanded(
                            child: Text(
                              widget.destination,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacing12),
                      
                      // Driver info
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: AppTheme.textSecondaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          Text(
                            '${widget.driverName} • ${widget.carModel} ${widget.plateNumber}',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppTheme.spacing12),
                      
                      // Total price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: AppTheme.titleMedium.copyWith(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${widget.totalPrice} RWF',
                            style: AppTheme.titleLarge.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Payment methods
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
                  child: Text(
                    'Choose Payment Method',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacing16),
                
                // Payment methods list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
                    itemCount: _paymentMethods.length,
                    itemBuilder: (context, index) {
                      return _buildPaymentMethodCard(_paymentMethods[index]);
                    },
                  ),
                ),
                
                // Confirm payment button
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    border: Border(
                      top: BorderSide(color: AppTheme.borderColor),
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        label: _selectedPaymentMethod.isEmpty 
                            ? 'Select payment method to continue'
                            : 'Confirm Payment',
                        isLoading: _isLoading,
                        onPressed: _selectedPaymentMethod.isEmpty ? null : _confirmPayment,
                        icon: Icons.payment,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
